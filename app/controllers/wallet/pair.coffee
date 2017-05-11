`import Ember from 'ember'`

RecoverController = Ember.Controller.extend(
  credentials: Ember.inject.service('cm-credentials')

  actions:
    abortWizard: (-> @transitionToRoute('wallet.welcome'))
)
`export default RecoverController`
