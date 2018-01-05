`import Ember from 'ember'`


FeesSelector = Ember.Component.extend(

  greaterThan: 0

  allFeesOptions: [
    {label: 'tx.fees.verylow', value: 0.5}
    {label: 'tx.fees.low', value: 0.75}
    {label: 'tx.fees.normal', value: 1.0}
    {label: 'tx.fees.high', value: 1.5}
    {label: 'tx.fees.veryhigh', value: 2.0}
  ]

  feesOptions: ( ->
    @get('allFeesOptions').filter((item) => (item.value > @get('greaterThan')))
  ).property('allFeesOptions', 'greaterThan')

  feesMult: 1.0

  feesOption: (->
    @get('feesOptions').findBy('value', @get('feesMult'))
  ).property('feesOptions', 'feesMult')

  checkSelection: (->
    if Ember.isEmpty(@get('feesOption'))
      if (mult = @get('feesOptions.firstObject.value'))
        @set('feesMult', mult)
        @sendAction('onchange', mult)
  ).on('didInsertElement')

  actions:
    setFees: (option) ->
      if (v = Ember.get(option, 'value'))
        @set('feesMult', v)
        @sendAction('onchange', v, @get('allFeesOptions').findBy('value', v))

)

`export default FeesSelector`


