`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

DisplayState = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  drivers: Ember.computed.alias('cm.config.tfaDrivers')
  devices: Ember.computed.alias('aa.tfaDevices')
  allDevices: Ember.computed.alias('aa.tfaAllDevices')

  incompleteDevices: Ember.computed.filterBy('devices', 'verified', false)
  completeDevices: Ember.computed.filterBy('devices', 'verified', true)

  currentError: null
  showEnroll: false

  apiOps: taskGroup().drop()
  tfaOps: taskGroup().drop()

  disableDevice:  task( (device)->
    api = @get('cm.api')
    aa = @get('aa')

    @set 'currentError', null

    operation = (tfa) ->
      api.tfaDeviceDelete(device, tfa.payload)

    try
      yield aa.tfaAuth(operation, "Disable Device")
      @get('refreshState').perform()

    catch error
      Ember.Logger.error "Error doing enroll finish: ", error
      @set 'currentError', error.msg
  ).group('tfaOps')

  refreshState: task( (device)->
    @set('showEnroll', false)
    yield @get('aa').refreshTfaState()
  )


  enrollFinish: task( (device, token)->
    @set 'currentError', null
    api = @get('cm.api')

    try
      yield api.tfaEnrollFinish(name: device.name, value: device.value, code: token)
      @get('refreshState').perform()
    catch error
      Ember.Logger.error "Error doing enroll finish: ", error
      @set 'currentError', error.msg

  ).group('apiOps')

  actions:

    disableDevice: (device) ->
      @get('disableDevice').perform(device)

    refreshState: ->
      @get('refreshState').perform()

    enrollShow: ->
      @set('showEnroll', true)

    enrollFinish: (device, token) ->
      @get('enrollFinish').perform(device, token)
)

`export default DisplayState`