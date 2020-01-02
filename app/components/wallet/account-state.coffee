import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

WalletAccountsDropdown = Component.extend(
  tagName: 'li'

  cm: service('cm-session')

  currentWallet: alias('cm.currentWallet')
  account: alias('cm.currentAccount')
  accounts: alias('cm.accounts')
)

export default WalletAccountsDropdown