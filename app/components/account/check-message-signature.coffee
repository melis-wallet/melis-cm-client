import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, taskGroup } from 'ember-concurrency'
import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'

import Logger from 'melis-cm-svcs/utils/logger'


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
    validator('coin-address', coin: alias('model.account.coin', ), allowURI: true)
  ]

)

CheckSignature = Component.extend(Validations, ValidationsHelper,

  cm: service('cm-session')

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
          console.error("check", {coin: @get('account.coin'), address: address, sign: signature, text: text.trim()})
          valid = @get('cm.api').verifyMessageSignature(@get('account.coin'), address, signature, text.trim())
          @setProperties
            result: true
            valid: valid

        catch error
          Logger.error "Error: ", error
)

export default CheckSignature

