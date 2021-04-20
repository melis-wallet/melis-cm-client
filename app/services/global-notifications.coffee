import Service, { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, set } from '@ember/object'

import CMCore from 'melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'

N = window.Notify.default
NOTIF_ICON = 'images/melis-icon.png'

C = CMCore.C

GlobalNotifications = Service.extend(

  cm: service('cm-session')
  cordovaPlatform: service('ember-cordova/platform')
  toasts: service('leaf-toasts')
  stream: service('cm-stream')
  coinsvc: service('cm-coin')
  device: service('device-support')
  i18n: service()
  routing: service('-routing')

  isMobile: alias('device.isMobile')
  hasPush: alias('isMobile')

  nativeEnabled: alias('cm.walletstate.nnenable')
  toastEnabled: alias('cm.walletstate.ianenable')
  pushEnabled: alias('cm.walletstate.pushenabled')



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
    if notif = get(data, 'cmNotif')
      try
        n = JSON.parse(notif)
      catch error
        Logger.error '* unable to deserialize push notification:', error

      if pubid = get(n, 'params.accountPubId')
        @get('cm.accounts').some( (acc) =>
          if acc.get('cmo.pubId') == pubid || acc.get('cmo.masterPubId') == pubid
            @switchAccountOnPush(acc)
        )

  switchAccountOnPush: (acc) ->
    if n = get(acc, 'pubId')
      Logger.debug "[Notif] Transition to account on push: ", n
      @get("routing").transitionTo('main.account.summary', [n])


  initializePush: ->
    return unless @get('pushSupported') && @get('hasPush')
    @switchPush()

    onMessage = (data) =>
      if data.wasTapped
        @handlePush(data)
      else
        Logger.debug('[NOTIF]', data)

    FCMPlugin.onNotification(onMessage, (->
      Logger.debug('[NOTIF] Registered CB')
    ),( ->
      Logger.error('[NOTIF] Failed registering CB')
    ))




  switchPush: (->
    return unless @get('pushSupported') && @get('hasPush')

    if @get('pushEnabled')
      FCMPlugin.getToken( ((token) =>
        if token
          Logger.debug('[NOTIF] Got FCM token: ', token)
          @get('cm.api').addPushTokenGoogle(token)

        ), ( -> Logger.error('[NOTIF] Error getting FCM token.'))
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

    acct = get(entry, 'account')
    return if (acct && get(acct, 'invisible'))

    # ignore wallet events for now
    if acct

      switch get(entry, 'subclass')
        when 'tx'
          if (get(entry, 'notifiable') == 'new') && !get(entry, 'notified')
            set(entry, 'notified', true)
            amount = @get('coinsvc').formatUnit(acct, Math.abs(get(entry, 'content.cmo.amount')))
            unit =  acct.get('subunit.symbol')

            body =
              if get(entry, 'content.negative')
                @get('i18n').t('notif.tx.sent', amount: amount, unit: unit)
              else
                @get('i18n').t('notif.tx.received', amount: amount, unit: unit)

            @showNotification(
              get(entry, 'account.name')
              severity: 'success'
              body: body
            )

        when 'ptx'
          return if get(entry, 'content.isLocal')
          if get(entry, 'content.isVerified') && !get(entry, 'notified')
            set(entry, 'notified', true)

            source = acct.cosignerName(get(entry, 'content.cmo.accountPubId'), you: @get('i18n').t('tx.you'))
            amount = @get('coinsvc').formatUnit(acct, get(entry, 'content.cmo.amount'))
            unit = acct.get('subunit.symbol')

            body = @get('i18n').t('notif.ptx.proposed', source: source, amount: amount, unit: unit)

            severity =
              if get(entry, 'content.accountIsOwner')
                'success'
              else
                'warning'

            @showNotification(
              get(entry, 'account.name')
              severity: 'success'
              body: body
            )

        when 'txm'
          msg = get(entry, 'content')
          from = get(msg, 'fromAlias') || acct.cosignerName(get(msg, 'fromPubId'))

          switch get(msg, 'type')
            when C.CHAT_MSG_TYPE_SIG
              body =  @get('i18n').t('notif.ptx.has-approved', source: from)
            when C.CHAT_MSG_TYPE_MSG
              body =  @get('i18n').t('notif.ptx.has-contributed', source: from)

          @showNotification(
            get(entry, 'account.name')
            severity: 'success'
            body: body
          )

        when 'evt'

          event = get(entry, 'content')
          acctN = get(entry, 'account.name')
          switch get(event, 'type')
            when 'joined'
              code = get(event, 'cmo.activationCode')
              body = @get('i18n').t('notif.evt.has-joined', subject: code.name, account: acctN)
            #when C.EVENT_JOIN_REQUEST
              # not implemented

          @showNotification(
            get(entry, 'account.name')
            severity: 'success'
            body: body
          )
    else
      switch get(entry, 'subclass')

        # events
        when 'evt'
          event = get(entry, 'content')
          switch get(event, 'type')

            when 'publicMsg'
              text = get(event, 'cmo.text')
              body = @get('i18n').t('notif.evt.wall', text: text)

              @showNotification(
                @get('i18n').t('notif.evt.wall-title').toString()
                severity: 'warning'
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

export default GlobalNotifications
