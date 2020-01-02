import Service, { inject as service } from '@ember/service'
import { get, set } from '@ember/object'

import CMCore from 'npm:melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'


C = CMCore.C

ToastsProvider = Service.extend(


  cm: service('cm-session')
  toasts: service('leaf-toasts')
  stream: service('cm-stream')
  chat: service('cm-chat')
  ptxsvc: service('cm-ptxs')

  i18n: service()


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
    account = get(ptx, 'account')
    if signer && (signer != account.get('cmo.pubId'))
      signerName = account.cosignerName(signer, {unknown: @get('i18n').t('toasts.ptx.cosigner')})
      text = @get('i18n').t('toasts.ptx.newsig', signer: signerName, account: account)
      @get('toasts').showSuccess(text)

  newPtxMsg: (msg, account) ->
    if get(account, 'cmo.pubId') != get(msg, 'fromPubId')
      if get(msg, 'type') == 'M'
        text = get(msg, 'payload.plaintext')
        if(text && (text.length > 30))
          text = text.substring(0, 27) + '...'
        if true  #|| @get('appState.ptxChatNotify')
          @get('toasts').showSuccess(text)


  streamEntry: (entry, account) ->
    name = account.get('name')
    newer = account.get('stream.newer.length')
    urgent = account.get('stream.urgentNewer.length')


    if urgent > 0
      text = @get('i18n').t('toasts.stream.urgent', name: name, count: urgent)
      @get('toasts').showWarn(text)
    if (newer - urgent) > 0
      text = @get('i18n').t('toasts.stream.entries', name: name, count: newer)
      @get('toasts').showSuccess(text)



  observeStreams: ( ->
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
    Logger.debug('== Starting toasts service')
  ).on('init')

  teardown: (->
  ).on('willDestroy')
)

export default ToastsProvider
