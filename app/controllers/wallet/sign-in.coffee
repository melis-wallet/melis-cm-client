`import Ember from 'ember'`

SignInController = Ember.Controller.extend(
  cm: Ember.inject.service('cm-session')

  ready: Ember.computed.alias('cm.ready')
  connected: Ember.computed.alias('cm.connected')
  disconnected: Ember.computed.alias('cm.disconnected')
  connectFailed: Ember.computed.alias('cm.connectFailed')


  noAccounts: Ember.computed.empty('cm.accounts')

)
`export default SignInController`
