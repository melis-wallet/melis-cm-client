`import Ember from 'ember'`

EnrollController = Ember.Controller.extend(
  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')


  connected: Ember.computed.alias('cm.connected')
  disconnected: Ember.computed.alias('cm.disconnected')
  connectFailed: Ember.computed.alias('cm.connectFailed')


  enrollRunning: false


  actions:
    startEnroll: ->
      @set 'enrollRunning', true
      false

    doneEnroll: ->
      @set 'enrollRunning', false
      false


)
`export default EnrollController`
