`import Ember from 'ember'`

WalletAccountsDropdown = Ember.Component.extend(
  tagName: 'li'

  classNames: ['dropdown']

  cm: Ember.inject.service('cm-session')

  currentWallet: Ember.computed.alias('cm.currentWallet')
  currentAccount: Ember.computed.alias('cm.currentAccount')
  accounts: Ember.computed.alias('cm.accounts')

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
      cm.selectAccount(acc.get('num'))

)

`export default WalletAccountsDropdown`