import { computed } from '@ember/object'
import { A } from '@ember/array'

import Model from './cm-model'
import { validator, buildValidations } from 'ember-cp-validations'
import { alias } from '@ember/object/computed'


Validations = buildValidations(
  info: [
    validator('presence', true)
    validator('length', min: 1, max: 250)
  ]
  amount: [
    validator('number', positive: true, allowString: true, allowBlank: true)
  ]
)

PaymentNewaddress = Model.extend(Validations, 

  address: null
  meta: {}
  labels: null

  amount: null


  info: computed('meta',
    get: (key) ->
      @get('meta.info')

    set: (key, val) ->
      meta = @get('meta') || {}
      meta.info = val
      @set('meta', meta)
      val
  )


  setup: (
    @set('labels', A())
  ).on('init')

  addressURL: (->
    if address = @get('address')
      "bitcoin:#{address}"
  ).property('address')


  isValid: alias('validations.isValid')
)

export default PaymentNewaddress
