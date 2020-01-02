import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { empty, alias } from '@ember/object/computed'

SignInController = Controller.extend(
  cm: service('cm-session')

  ready: alias('cm.ready')
  connected: alias('cm.connected')
  disconnected: alias('cm.disconnected')
  connectFailed: alias('cm.connectFailed')

  noAccounts: empty('cm.accounts')

)

export default SignInController
