`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

DeviceRecovery = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  recovering: false
  doneRequest: false
  error: false


  doRecovery: task( ->
    api = @get('cm.api')
    @set 'error', false

    op = (tfa) ->
      api.tfaProposeDeleteDevices()

    try
      res = yield @get('aa').askLocalPin(op, "Reset TFA Devices")
      @set 'doneRequest', true
    catch error
      Ember.Logger.error('Error resetting TFA', error)
      @set 'error', true
  )

  actions:
    startRecovery: ->
      @set('recovering', true)

    resetRequest: ->
      @setProperties
        recovering: false
        error: false


    doRecovery: ->
      @get('doRecovery').perform()

)

`export default DeviceRecovery`
