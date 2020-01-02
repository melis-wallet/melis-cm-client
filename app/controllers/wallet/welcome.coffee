import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

EnrollController = Controller.extend(
  cm: service('cm-session')
  credentials: service('cm-credentials')


  connected: alias('cm.connected')
  disconnected: alias('cm.disconnected')
  connectFailed: alias('cm.connectFailed')

  enrollRunning: false

  actions:
    startEnroll: ->
      @set 'enrollRunning', true
      false

    doneEnroll: ->
      @set 'enrollRunning', false
      false
)

export default EnrollController
