import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, filterBy } from '@ember/object/computed'
import { get } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


SUPPORTED_DRIVERS=['email', 'telegram', 'rfc6238', 'xmpp', 'regtest']

DisplayState = Component.extend(


  cm: service('cm-session')
  aa: service('aa-provider')

  drivers: alias('cm.config.tfaDrivers')
  devices: alias('aa.tfaDevices')
  allDevices: alias('aa.tfaAllDevices')

  incompleteDevices: filterBy('devices', 'verified', false)
  completeDevices: filterBy('devices', 'verified', true)

  activeDrivers: ( ->
    @get('drivers')?.filter((d) -> SUPPORTED_DRIVERS.includes(get(d, 'name')))
  ).property('drivers')


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
      Logger.error "Error doing enroll finish: ", error
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
      Logger.error "Error doing enroll finish: ", error
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

export default DisplayState