`import Ember from 'ember'`


AccountSelector = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  exclude: null

  # same coin as this account
  coin: null


  accounts: Ember.computed.filter('cm.accounts', ((acc, idx) ->
    return false if (pubId = @get('exclude.pubId')) && (Ember.get(acc, 'pubId') == pubId)

    if (coin = @get('coin'))
      Ember.get(acc, 'coin') == coin
    else
      true
  ))

  selected: null


  actions:
    changedAccount: (account) ->
      @sendAction 'on-account-change', account

)

`export default AccountSelector`


