`import Ember from 'ember'`

WalletController = Ember.Controller.extend(
  cm: Ember.inject.service('cm-session')

  ready: Ember.computed.alias('cm.ready')
  connected: Ember.computed.alias('cm.connected')
  disconnected: Ember.computed.alias('cm.disconnected')
  connectFailed: Ember.computed.alias('cm.connectFailed')


)
`export default WalletController`
