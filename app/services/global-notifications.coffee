`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

N = window.Notify.default
NOTIF_ICON = 'images/melis-icon.png'

C = CMCore.C

GlobalNotifications = Ember.Service.extend(

  cm: Ember.inject.service('cm-session')
  cordovaPlatform: Ember.inject.service('ember-cordova/platform')
  toasts: Ember.inject.service('leaf-toasts')
  stream: Ember.inject.service('cm-stream')
  coinsvc: Ember.inject.service('cm-coin')
  device: Ember.inject.service('device-support')
  i18n: Ember.inject.service()
  routing: Ember.inject.service('-routing')

  isMobile: Ember.computed.alias('device.isMobile')
  hasPush: Ember.computed.alias('isMobile')

  nativeEnabled: Ember.computed.alias('cm.walletstate.nnenable')
  toastEnabled: Ember.computed.alias('cm.walletstate.ianenable')
  pushEnabled: Ember.computed.alias('cm.walletstate.pushenabled')



  nativeSupported: true
  nativePermitted: false
  nativeDenied: false

  pushSupported: ( -> FCMPlugin? ).property()


  showNative: ( ->
    if @get('pushEnabled')
      @get('nativeEnabled') && !@get('device.paused')
    else
      @get('nativeEnabled')
  ).property('nativeEnabled', 'pushEnabled', 'device.paused')


  resetAll: ->
    @setProperties
      nativeEnabled: false
      toastEnabled: false
      pushEnabled: false

  handlePush: (data) ->
    #console.error "PUSH: ", data
    if notif = Ember.get(data, 'cmNotif')
      try
        n = JSON.parse(notif)
      catch error
        Ember.Logger.error '* unable to deserialize push notification:', error

      if pubid = Ember.get(n, 'params.accountPubId')
        @get('cm.accounts').some( (acc) =>
          if acc.get('cmo.pubId') == pubid || acc.get('cmo.masterPubId') == pubid
            @switchAccountOnPush(acc)
        )

  switchAccountOnPush: (acc) ->
    if n = Ember.get(acc, 'pubId')
      Ember.Logger.debug "[Notif] Transition to account on push: ", n
      @get("routing").transitionTo('main.account.summary', [n])


  initializePush: ->
    return unless @get('pushSupported') && @get('hasPush')
    @switchPush()

    onMessage = (data) =>
      if data.wasTapped
        @handlePush(data)
      else
        Ember.Logger.debug('[NOTIF]', data)

    FCMPlugin.onNotification(onMessage, (->
      Ember.Logger.debug('[NOTIF] Registered CB')
    ),( ->
      Ember.Logger.error('[NOTIF] Failed registering CB')
    ))




  switchPush: (->
    return unless @get('pushSupported') && @get('hasPush')

    if @get('pushEnabled')
      FCMPlugin.getToken( ((token) =>
        if token
          Ember.Logger.debug('[NOTIF] Got FCM token: ', token)
          @get('cm.api').addPushTokenGoogle(token)

        ), ( -> Ember.Logger.error('[NOTIF] Error getting FCM token.'))
      )
    else
      @get('cm.api').addPushTokenGoogle(null)

  ).observes('pushEnabled')



  initializeNative: (->

    if @get('nativeEnabled')
      @checkNativePermission()

  ).observes('nativeEnabled').on('init')


  checkNativePermission: (force) ->
    self = @
    @set('nativeDenied', false)

    return new Promise((resolve, reject) ->
      if !self.get('nativePermitted') || force
        if !N.needsPermission
          self.setProperties
            nativePermitted: true
            nativeSupported: true
          resolve()
        else if N.isSupported()
          N.requestPermission((->
            # user permitted
            self.setProperties
              nativePermitted: true
              nativeSupported: true
            resolve()
          ), ( ->
            # user denied
            self.setProperties
              nativePermitted: false
              nativeSupported: true
              nativeEnabled: false
              nativeDenied: true
            reject('denied')
          ))
        else
          self.setProperties
            nativePermitted: false
            nativeSupported: false
            nativeEnabled: false
          reject('not-supported')
      else
        resolve()
    )


  showNotification: (title, data)->
    if document.hidden && @get('nativeEnabled')
      @nativeNotification(title, data)
    else
      @toastNotification(title, data)

  streamEntry: (entry) ->

    acct = Ember.get(entry, 'account')
    return if (acct && Ember.get(acct, 'invisible'))

    # ignore wallet events for now
    return unless acct

    switch Ember.get(entry, 'subclass')
      when 'tx'
        if (Ember.get(entry, 'notifiable') == 'new') && !Ember.get(entry, 'notified')
          Ember.set(entry, 'notified', true)
          amount = @get('coinsvc').formatUnit(acct, Math.abs(Ember.get(entry, 'content.cmo.amount')))
          unit =  @get('cm.btcUnit')

          body =
            if Ember.get(entry, 'content.negative')
              @get('i18n').t('notif.tx.sent', amount: amount, unit: unit)
            else
              @get('i18n').t('notif.tx.received', amount: amount, unit: unit)

          @showNotification(
            Ember.get(entry, 'account.name')
            severity: 'success'
            body: body
          )

      when 'ptx'
        return if Ember.get(entry, 'content.isLocal')
        if Ember.get(entry, 'content.isVerified') && !Ember.get(entry, 'notified')
          Ember.set(entry, 'notified', true)

          source = acct.cosignerName(Ember.get(entry, 'content.cmo.accountPubId'), you: @get('i18n').t('tx.you'))
          amount = @get('coinsvc').formatUnit(acct, Ember.get(entry, 'content.cmo.amount'))
          unit =  @get('cm.btcUnit')

          body = @get('i18n').t('notif.ptx.proposed', source: source, amount: amount, unit: unit)

          severity =
            if Ember.get(entry, 'content.accountIsOwner')
              'success'
            else
              'warning'

          @showNotification(
            Ember.get(entry, 'account.name')
            severity: 'success'
            body: body
          )

      when 'txm'
        msg = Ember.get(entry, 'content')
        from = Ember.get(msg, 'fromAlias') || acct.cosignerName(Ember.get(msg, 'fromPubId'))

        switch Ember.get(msg, 'type')
          when C.CHAT_MSG_TYPE_SIG
            body =  @get('i18n').t('notif.ptx.has-approved', source: from)
          when C.CHAT_MSG_TYPE_MSG
            body =  @get('i18n').t('notif.ptx.has-contributed', source: from)

        @showNotification(
          Ember.get(entry, 'account.name')
          severity: 'success'
          body: body
        )

      when 'evt'

        event = Ember.get(entry, 'content')
        acctN = Ember.get(entry, 'account.name')
        switch Ember.get(event, 'type')
          when 'joined'
            code = Ember.get(event, 'cmo.activationCode')
            body = @get('i18n').t('notif.evt.has-joined', subject: code, account: acctN)
          #when C.EVENT_JOIN_REQUEST
            # not implemented


        @showNotification(
          Ember.get(entry, 'account.name')
          severity: 'success'
          body: body
        )

  toastNotification: (title, data) ->
    return unless @get('toastEnabled')

    @get('toasts').queueToast
      message: "<b>#{title}:</b>#{data.body}"
      type: data.severity


  nativeNotification: (title, data) ->
    return unless @get('showNative')

    data.icon ||= NOTIF_ICON
    n = new N(title, data)
    n.show()


  setup: ( ->
    @getProperties('nativeEnabled', 'pushEnabled')
    @get('stream').on('notifiable-entry', this, @streamEntry)

    if @get('isMobile')
      @initializePush()
    else
      @set('pushEnabled', false)
  ).on('init')


  teardown: (->
    @get('stream').off('notifiable-entry', this, @streamEntry)
  ).on('willDestroy')


)

`export default GlobalNotifications`
