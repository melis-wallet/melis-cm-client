`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`



Validations = buildValidations(
  token: [
    validator('presence', true)
    validator('length', is: 8)
  ]
)

TokenInput = Ember.Component.extend(Validations, ValidationsHelper,

  aa: Ember.inject.service('aa-provider')

  validateError: false
  invalidToken: false

  enterToken: task((token) ->
    @setProperties
      validateError: false
      invalidToken: false

    try
      res = yield @get('aa').validateInvite(token)
      if res
        @sendAction('on-valid-token', token)
      else
        @set 'invalidToken', true
    catch e
      @set 'validateError', true
  ).drop()

  actions:
    enterToken: ->
      if @get('isValid') && (token = @get('token'))
        @get('enterToken').perform(token)



)

`export default TokenInput`
