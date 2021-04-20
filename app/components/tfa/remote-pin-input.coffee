import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { schedule, later } from '@ember/runloop'

import { validator, buildValidations } from 'ember-cp-validations'
import Fpa from 'melis-cm-client/mixins/fingerprint-auth'

Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

RemotePinInput = Component.extend(Validations, Fpa,

  cm: service('cm-session')
  credentials: service('cm-credentials')

  data: null
  pin: null

  inputId: 'pin_input_r'

  onValidFpa: (pin) ->
    @set('pin', pin)
    @sendAction('on-valid-pin', pin)

  setup: (->
    schedule 'afterRender', this, (->
      later(this, (-> @.$('input#' + @get('inputId'))?.focus()), 500)
    )
  ).on('didInsertElement')

  actions:
    enterPIN: ->
      if @get('validations.isValid')
        @sendAction('on-valid-pin', @get('pin'))
)

export default RemotePinInput
