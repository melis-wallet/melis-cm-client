`import Ember from 'ember'`

MainController = Ember.Controller.extend(

  media: Ember.inject.service('responsive-media')
  stream:  Ember.inject.service('cm-stream')
  toastsSvc: Ember.inject.service('cm-toasts-provider')
  accountInfo: Ember.inject.service('cm-account-info')
  accountEvts: Ember.inject.service('cm-account-events')
  walletsvc: Ember.inject.service('cm-wallet')
  addrSvc: Ember.inject.service('cm-address-provider')
  txinfo: Ember.inject.service('cm-tx-infos')
  ptxsvc: Ember.inject.service('cm-ptxs')
  glbNotif: Ember.inject.service('global-notifications')

  app_state: Ember.inject.service('app-state')
  scanner: Ember.inject.service('scanner-provider')

  setup: ( ->
    # force preloading of services
    @getProperties(
      'stream',
      'toastsSvc',
      'accountInfo',
      'accountEvts',
      'walletsvc',
      'addrSvc',
      'txinfo',
      'ptxsvc',
      'glbNotif'
    )
  ).on('init')


  actions:
    selectMmClose: ->
      @get('app_state').routingStateChanged()

    startGenericScanner: ->
      @get('scanner').startGenericScanner(redirect: true)

)

`export default MainController`
