import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'
import { schedule, later } from '@ember/runloop'

import PinInputMixin from '../../mixins/pin-input'
import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import Fpa from 'melis-cm-client/mixins/fingerprint-auth'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

PinInput = Component.extend(Validations, ValidationsHelper, Fpa,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  routing: service('-routing')

  apiOps: taskGroup().drop()

  tryLastAttempt: false

  attemptsLeft: null
  devicePass: null
  pin: null

  pinError: null

  locked: false

  inputId: 'pin_input'

  lowAttempts: (->
    left = @get('credentials.attemptsLeft')
    (left == 1)
  ).property('credentials.attemptsLeft')

  noValidCreds: ( ->
    if !@get('credentials.validCredentials')
      @get('routing').transitionTo('wallet.no-creds')
  ).observes('credentials.validCredentials')

  attemptsType: (->
    if @get('lowAttempts')
      'warning'
    else
      'default'
  ).property('lowAttempts')

  setup: (->
    schedule 'afterRender', this, (->
      later(this, (-> @.$('input#' + @get('inputId'))?.focus()), 500)
    )
  ).on('didInsertElement')

  onValidFpa: (pin) ->
    @get('enterPIN').perform(pin)

  enterPIN: task( (pin) ->
    @set('pinError', null)

    try
      res = yield @get('cm').deviceGetPassword(pin)
      if !res
        @setProperties
          pinError: 'Server Error'
      else if res.password
        @set 'devicePass', res.password
        @sendAction('on-valid-pin', @get('pin'), @get('devicePass'))
      else if res.attemptsLeft
        @setProperties
          pinError: "Wrong Pin"
          pin: null
        @sendAction('on-wrong-pin')
    catch error
      if error.ex == 'CmInvalidDeviceException'
        if error.attemptsLeft
          @set 'pinError', "Wrong Pin"
          @sendAction('on-wrong-pin')
        else
          @setProperties
            locked: true
            pin: null
          @get('cm').resetApp()
      else
        Logger.error('Enter failed: ', error)
  )

  actions:
    enterPIN: ->
      if pin = @get('pin')
        @get('enterPIN').perform(pin)
)

export default PinInput
