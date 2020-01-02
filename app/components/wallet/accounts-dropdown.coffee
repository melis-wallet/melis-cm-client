import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


WalletAccountsDropdown = Component.extend(
  tagName: 'li'

  classNames: ['dropdown']

  cm: service('cm-session')

  currentWallet: alias('cm.currentWallet')
  currentAccount: alias('cm.currentAccount')
  accounts: alias('cm.accounts')

  name: (->
    @get('currentAccount.meta.name')
  ).property('currentAccount')


  actions:
    walletClose: ->
      cm = @get('cm')
      cm.walletClose().then(->
        window.location.reload()
      )

    selectAccount: (acc) ->
      cm = @get('cm')
      cm.selectAccount(acc.get('pubId'))

)

export default WalletAccountsDropdown