`import Ember from 'ember'`
`import Model from './cm-model'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`


Validations = buildValidations(
  info: [
    validator('presence', true)
    validator('length', min: 1, max: 250)
  ]
  amount: [
    validator('number', positive: true, allowString: true, allowBlank: true)
  ]
)

PaymentNewaddress = Model.extend(Validations, ValidationsHelper,

  address: null
  meta: {}
  labels: null

  amount: null


  info: Ember.computed('meta',
    get: (key) ->
      @get('meta.info')

    set: (key, val) ->
      meta = @get('meta') || {}
      meta.info = val
      @set('meta', meta)
      val
  )


  setup: (
    @set('labels', Ember.A())
  ).on('init')

  addressURL: (->
    if address = @get('address')
      "bitcoin:#{address}"
  ).property('address')

)

`export default PaymentNewaddress`
