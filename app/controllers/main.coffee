import Controller from '@ember/controller'
import { inject as service } from '@ember/service'

MainController = Controller.extend(

  media: service('responsive-media')
  coin:  service('cm-coin')
  stream:  service('cm-stream')
  toastsSvc: service('cm-toasts-provider')
  accountInfo: service('cm-account-info')
  accountEvts: service('cm-account-events')
  walletsvc: service('cm-wallet')
  addrSvc: service('cm-address-provider')
  txinfo: service('cm-tx-infos')
  ptxsvc: service('cm-ptxs')
  glbNotif: service('global-notifications')

  app_state: service('app-state')
  scanner: service('scanner-provider')

  init: ->
    @_super()
    # force preloading of services
    @getProperties(
      'coin',
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
  


  actions:
    selectMmClose: ->
      @get('app_state').routingStateChanged()

    startGenericScanner: ->
      @get('scanner').startGenericScanner(redirect: true)

)

export default MainController
