`import Ember from 'ember'`

FundsReminder = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  account: null
)

`export default FundsReminder`
