`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

Validations = buildValidations(
  signature: [
    validator('presence', true)
    validator('length', min: 88, max: 88)
  ]
  text: [
    validator('presence', true)
    validator('length', min: 1, max: 500)
  ]
  address: [
    validator('presence', presence: true)
    validator('bitcoin-address')
  ]

)

CheckSignature = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')

  account: null

  address: null
  text: null
  signature: null

  result: null
  valid: false

  textChanged: ( -> @setProperties(result: null, valid: false) ).observes('text')


  actions:
    doCheck: ->
      {text, address, signature} = @getProperties('text', 'address', 'signature')

      if text && address && signature
        try
          valid = @get('cm.api').verifyBitcoinMessageSignature(address, signature, text.trim())
          @setProperties
            result: true
            valid: valid

        catch error
          Ember.Logger.error "Error: ", error

)

`export default CheckSignature`
