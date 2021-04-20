import Component from '@ember/component'
import { schedule } from '@ember/runloop'

import { validator, buildValidations } from 'ember-cp-validations'

Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]

  pinCheck: [
    validator('confirmation', on: 'pin')
  ]
)

SetPinInput = Component.extend(Validations, 

  pin: null
  pinCheck: null

  pinChanged: (->
    @validate()
  ).observes('pin')

  submitPin: ->
    if @get('validations.isValid')
      @sendAction('on-set-pin', @get('pin'))

  actions:
    submitNewPIN: ->
      @submitPin()



)

export default SetPinInput
