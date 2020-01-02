import Component from '@ember/component'
import { schedule } from '@ember/runloop'

import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'

Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]

  pinCheck: [
    validator('confirmation', on: 'pin')
  ]
)

SetPinInput = Component.extend(Validations, ValidationsHelper,

  pin: null
  pinCheck: null

  listenKeypress: (->
    schedule 'afterRender', this, (->
      # ember-rapid-forms seems to have an 'autofocus' attribute, it just doesn't do anything
      @.$('input#set_pin_input').focus()
      # listen to keypresses to submit with enter pinCheck /ugly/fixme/
      @.$('input#set_pin_check').keypress( (e) =>
        if (e.which == 10 || e.which == 13)
          @submitPin()
      )
    )
  ).on('didInsertElement')

  pinChanged: (->
    @validate()
  ).observes('pin')

  submitPin: ->
    if @get('isValid')
      @sendAction('on-set-pin', @get('pin'))

  actions:
    submitNewPIN: ->
      @submitPin()



)

export default SetPinInput
