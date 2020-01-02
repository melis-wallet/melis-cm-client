import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import CMCore from 'npm:melis-api-js'
import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import TrackEvents from '../../mixins/track-events'
import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


C = CMCore.C

Validations = buildValidations(
  deviceName: [
    validator('presence', true)
    validator('length', min: 4, max: 16)
  ]
)


PairExportWizard = Component.extend(AsWizard, Validations, ValidationsHelper, TrackEvents,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  resp: service('responsive-media')


  apiOps: taskGroup().drop()

  pin: '1234'

  secret: null
  deviceId: null

  newDeviceName: 'My New Device'
  deviceName: null

  step: 1
  stepBack: true

  completeOn: 3

  codeSize: ( ->
    if @get('resp.isMobile')
      256
    else
      320
  ).property('resp.isMobile')


  requestPair: task((pin, deviceName) ->
    try
      res = yield @get('cm').exportForPairing(pin, deviceName)
      @setProperties
        secret: res.secret
        deviceId: res.deviceId

    catch e
      Logger.error "Error: ", e
  ).group('apiOps')

  pairCompleted: ->
    @setProperties
      pin: null
      secret: null
      deviceId: null
    @markCompleted(3)
    @sendAction('on-done')


  deviceDeleted: (data) ->
    if get(data, 'id') == @get('deviceId')
      @pairCompleted()


  setup: ( ->
    @trackEvent C.EVENT_DEVICE_DELETED, ((data) => @deviceDeleted(data))
  ).on('init')

  actions:
    requestPair: ->
      @get('requestPair').perform(@get('pin'), @get('newDeviceName'))

    failedPIN: ->
      @clearCompleted()


    doneEnterPIN: (pin) ->
      # if pin is entered, the whole wizard is invalid
      @clearCompleted()
      @setProperties
        pin: pin
        deviceName: @get('newDeviceName')
      @markCompleted(1, 2)


    doneNameSelect: ->
      @markCompleted(2, 3)
      @get('requestPair').perform(@get('pin'), @get('deviceName'))

)

export default PairExportWizard
