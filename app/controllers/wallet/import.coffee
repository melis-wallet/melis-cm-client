`import Ember from 'ember'`

ImportController = Ember.Controller.extend(
  credentials: Ember.inject.service('cm-credentials')

  actions:
    abortWizard: (-> @transitionToRoute('wallet.welcome'))
)
`export default ImportController`
