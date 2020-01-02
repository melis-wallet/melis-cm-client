import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

WalletController = Controller.extend(
  cm: service('cm-session')

  ready: alias('cm.ready')
  connected: alias('cm.connected')
  disconnected: alias('cm.disconnected')
  connectFailed: alias('cm.connectFailed')
)

export default WalletController
