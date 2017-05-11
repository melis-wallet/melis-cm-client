`import Ember from 'ember'`

PairController = Ember.Controller.extend(
  credentials: Ember.inject.service('cm-credentials')

  actions:
    abortWizard: (-> @transitionToRoute('wallet.welcome'))
)
`export default PairController`
