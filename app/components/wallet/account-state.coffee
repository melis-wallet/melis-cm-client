`import Ember from 'ember'`

WalletAccountsDropdown = Ember.Component.extend(
  tagName: 'li'

  cm: Ember.inject.service('cm-session')

  currentWallet: Ember.computed.alias('cm.currentWallet')
  account: Ember.computed.alias('cm.currentAccount')
  accounts: Ember.computed.alias('cm.accounts')
)

`export default WalletAccountsDropdown`