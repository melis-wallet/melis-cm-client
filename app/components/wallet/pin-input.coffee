`import Ember from 'ember'`
`import PinInputMixin from '../../mixins/pin-input'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, taskGroup } from 'ember-concurrency'`

Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

PinInput = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')
  routing: Ember.inject.service('-routing')

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
    Ember.run.schedule 'afterRender', this, (->

      @.$('input#pin_input').focus()
    )
  ).on('didInsertElement')


  enterPIN: task( (pin) ->
    @set('pinError', null)

    try
      res = yield @get('cm').deviceGetPassword(pin)
      if !res
        @set 'locked', true
        @set 'pin', null
      else if res.password
        @set 'devicePass', res.password
        @sendAction('on-valid-pin', @get('pin'), @get('devicePass'))
      else if res.attemptsLeft
        @set 'pinError', "Wrong Pin"
        @sendAction('on-wrong-pin')
    catch error
      if error.ex == 'CmInvalidDeviceException'
        if error.attemptsLeft
          @set 'pinError', "Wrong Pin"
          @sendAction('on-wrong-pin')
        else
          @set 'locked', true
          @set 'pin', null
      else
        Ember.Logger.error('Enter failed: ', error)
  )

  actions:
    enterPIN: ->
      if pin = @get('pin')
        @get('enterPIN').perform(pin)


)

`export default PinInput`
