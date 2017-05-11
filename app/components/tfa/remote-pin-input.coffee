`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import Fpa from 'melis-cm-client/mixins/fingerprint-auth'`

Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)


RemotePinInput = Ember.Component.extend(Validations, ValidationsHelper, Fpa,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')

  data: null
  pin: null

  onValidFpa: (pin) ->
    @set('pin', pin)
    @sendAction('on-valid-pin', pin)

  setup: (->
    Ember.run.later(this, (-> @.$('input#pin_input')?.focus()), 500)
  ).on('didInsertElement')



  actions:
    enterPIN: ->
      if @get('isValid')
        @sendAction('on-valid-pin', @get('pin'))


)

`export default RemotePinInput`
