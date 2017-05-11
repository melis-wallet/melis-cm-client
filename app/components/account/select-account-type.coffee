`import Ember from 'ember'`
`import Account from 'melis-cm-svcs/models/account'`

SelectAccountType = Ember.Component.extend(

  acct: Ember.inject.service('cm-account-info')

  accountType: null
  accountTypes: Account.accountTypes.filterBy('canCreate', true)

)
`export default SelectAccountType`