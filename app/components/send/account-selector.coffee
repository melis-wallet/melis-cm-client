`import Ember from 'ember'`


AccountSelector = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  accounts: Ember.computed.filter('cm.accounts', ((acc, idx) ->
    Ember.get(acc, 'num') != @get('cm.currentAccount.num')
  ))

  selected: null


  actions:
    changedAccount: (account) ->
      @sendAction 'on-account-change', account

)

`export default AccountSelector`


