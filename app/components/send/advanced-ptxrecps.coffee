`import Ember from 'ember'`

AdvancedListRecps = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  account: null

  parent: null
  reqRecipients: null

  preparedTx: null

  preparedRecps: Ember.computed.alias('preparedTx.cmo.recipients')
  preparedFees: Ember.computed.alias('preparedTx.cmo.fees')
  preparedAmount: Ember.computed.alias('preparedTx.cmo.amount')

  preparedTotal: ( ->
    @get('preparedAmount') + @get('preparedFees')
  ).property('preparedAmount', 'preparedFees')


  # recipients that are not remainders
  normalPRcpts: Ember.computed.filter('preparedRecps', (r) -> !Ember.get(r, 'isRemainder'))
  remainderPRcpts: Ember.computed.filter('preparedRecps', (r) -> Ember.get(r, 'isRemainder'))

  normalPRAmounts: Ember.computed.mapBy('normalPRcpts', 'amount')
  normalPRSum: Ember.computed.sum('normalPRAmounts')

  reqTotal: Ember.computed.alias('parent.totalAmount')
  isEntireBalance: Ember.computed.alias('parent.isEntireBalance')

  preparedRemainder: ( ->
    @get('preparedAmount') - @get('normalPRSum') - @get('preparedFees')
  ).property('preparedRecps', 'normalPRSum', 'preparedFees', 'preparedAmount')

  actions:
    deleteRecipient: (r) ->
      @sendAction('on-delete', r)

)

`export default AdvancedListRecps`
