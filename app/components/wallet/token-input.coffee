import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { task, taskGroup } from 'ember-concurrency'
import { validator, buildValidations } from 'ember-cp-validations'


Validations = buildValidations(
  token: [
    validator('presence', true)
    validator('length', is: 8)
  ]
)

TokenInput = Component.extend(Validations,

  aa: service('aa-provider')

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
      if @get('validations.isValid') && (token = @get('token'))
        @get('enterToken').perform(token)



)

export default TokenInput
