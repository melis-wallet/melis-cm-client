import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


DeviceRecovery = Component.extend(

  cm: service('cm-session')
  aa: service('aa-provider')

  recovering: false
  doneRequest: false
  error: false


  doRecovery: task( ->
    api = @get('cm.api')
    @set 'error', false

    op = (tfa) ->
      api.tfaProposeDeleteDevices()

    try
      res = yield @get('aa').askLocalPin(op, "Reset TFA Devices", true, true)
      @set 'doneRequest', true
    catch error
      Logger.error('Error resetting TFA', error)
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

export default DeviceRecovery
