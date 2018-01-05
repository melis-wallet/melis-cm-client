`import Ember from 'ember'`

CreateAccountController = Ember.Controller.extend(
  cm: Ember.inject.service('cm-session')

  actions:
    wizardComplete: (account)->
      if account
        @transitionToRoute('main.account.summary', Ember.get(account, 'pubId'))
      else
         @transitionToRoute('index')



)
`export default CreateAccountController`
