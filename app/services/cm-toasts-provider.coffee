`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C

ToastsProvider = Ember.Service.extend(


  cm: Ember.inject.service('cm-session')
  toasts: Ember.inject.service('leaf-toasts')
  stream: Ember.inject.service('cm-stream')
  chat: Ember.inject.service('cm-chat')
  ptxsvc: Ember.inject.service('cm-ptxs')

  i18n: Ember.inject.service()


  newNotif: (notif) ->

    toast =
      switch notif.get('subclass')
        when 'tx' then true #fixme
        when 'event' then true
        else
          false

    if toast
      @get('toasts').showSuccess(notif.get('title'))


  newSigReq: (ptx) ->
    owner = ptx.get('ownerName') || @get('i18n').t('toasts.ptx.cosigner')

    text = @get('i18n').t('toasts.ptx.newtx', owner: owner, account: ptx.get('account.name'))
    @get('toasts').showWarn(text)

  newSig: (signer, enough, ptx) ->
    account = Ember.get(ptx, 'account')
    if signer && (signer != account.get('cmo.pubId'))
      signerName = account.cosignerName(signer, {unknown: @get('i18n').t('toasts.ptx.cosigner')})
      text = @get('i18n').t('toasts.ptx.newsig', signer: signerName, account: account)
      @get('toasts').showSuccess(text)

  newPtxMsg: (msg, account) ->
    if Ember.get(account, 'cmo.pubId') != Ember.get(msg, 'fromPubId')
      if Ember.get(msg, 'type') == 'M'
        text = Ember.get(msg, 'payload.plaintext')
        if(text && (text.length > 30))
          text = text.substring(0, 27) + '...'
        if true  #|| @get('appState.ptxChatNotify')
          @get('toasts').showSuccess(text)


  streamEntry: (entry, account) ->
    name = account.get('name')
    newer = account.get('stream.newer.length')
    urgent = account.get('stream.urgentNewer.length')

    console.error "STREAM", urgent, newer, account

    if urgent > 0
      text = @get('i18n').t('toasts.stream.urgent', name: name, count: urgent)
      @get('toasts').showWarn(text)
    if (newer - urgent) > 0
      console.error "displaying newer"
      text = @get('i18n').t('toasts.stream.entries', name: name, count: newer)
      @get('toasts').showSuccess(text)



  observeStreams: ( ->
    console.error("OBSERVER")
    @get('cm.accounts').forEach((account) =>
      newer = account.get('stream.newer.length')
      urgent = account.get('stream.urgentNewer.length')
      name  = account.get('name')

      if (urgent > 0) && (urgent != account.get('stream.seenUrgent'))
        account.set('stream.seenUrgent', urgent)
        text = @get('i18n').t('toasts.stream.urgent', name: name, count: urgent)
        @get('toasts').showWarn(text)

      if ((newer - urgent) > 0) && (newer != account.get('stream.seenNewer'))
        account.set('stream.seenNewer', newer)
        text = @get('i18n').t('toasts.stream.entries', name: name, count: newer)
        @get('toasts').showSuccess(text)
    )
  ).observes('cm.accounts.@each.stream.newer.length')

  setup: ( ->
    Ember.Logger.debug('== Starting toasts service')

  #  @get('ptxsvc').on('new-sig-requested', this, @newSigReq)
  #  @get('ptxsvc').on('new-sig', this, @newSig)
  #  @get('chat').on('msg-to-ptx', this, @newPtxMsg)
  # @get('stream').on('new-entry', this, @streamEntry)
  ).on('init')


  teardown: (->
  #  @get('ptxsvc').off('new-sig-requested', this, @newSigReq)
  #  @get('ptxsvc').off('new-sig', this, @newSig)
  #  @get('chat').off('msg-to-ptx', this, @newMsg)
  # @get('stream').off('new-entry', this, @streamEntry)
  ).on('willDestroy')
)

`export default ToastsProvider`
