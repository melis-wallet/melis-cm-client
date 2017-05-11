`import Ember from 'ember'`

EnrollController = Ember.Controller.extend(
  credentials: Ember.inject.service('cm-credentials')
)
`export default EnrollController`
