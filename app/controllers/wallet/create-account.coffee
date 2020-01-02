import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

CreateAccountController = Controller.extend(
  cm: service('cm-session')

  actions:
    wizardComplete: (account)->
      if account
        @transitionToRoute('main.account.summary', get(account, 'pubId'))
      else
         @transitionToRoute('index')



)
`export default CreateAccountController`
