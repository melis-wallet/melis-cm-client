import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import Logger from 'melis-cm-svcs/utils/logger'

WalletController = Controller.extend(
  cm: service('cm-session')

  ready: alias('cm.ready')
  connected: alias('cm.connected')
  disconnected: alias('cm.disconnected')
  connectFailed: alias('cm.connectFailed')


  actions:
    retryConnect: ->
      Logger.info('[wallet] Manually retrying connect')
      @get('cm').connect().then( -> Logger.info('[wallet] Connect Success') )

)

export default WalletController
