import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, filter, mapBy, sum } from '@ember/object/computed'
import { get, set } from '@ember/object'

AdvancedListRecps = Component.extend(

  cm: service('cm-session')

  account: null

  parent: null
  reqRecipients: null

  preparedTx: null

  preparedRecps: alias('preparedTx.cmo.recipients')
  preparedFees: alias('preparedTx.cmo.fees')
  preparedAmount: alias('preparedTx.cmo.amount')

  preparedTotal: ( ->
    @get('preparedAmount') + @get('preparedFees')
  ).property('preparedAmount', 'preparedFees')


  # recipients that are not remainders
  normalPRcpts: filter('preparedRecps', (r) -> !get(r, 'isRemainder'))
  remainderPRcpts: filter('preparedRecps', (r) -> get(r, 'isRemainder'))

  normalPRAmounts: mapBy('normalPRcpts', 'amount')
  normalPRSum: sum('normalPRAmounts')

  reqTotal: alias('parent.totalAmount')
  isEntireBalance: alias('parent.isEntireBalance')

  preparedRemainder: ( ->
    @get('preparedAmount') - @get('normalPRSum') - @get('preparedFees')
  ).property('preparedRecps', 'normalPRSum', 'preparedFees', 'preparedAmount')

  actions:
    deleteRecipient: (r) ->
      @sendAction('on-delete', r)

)

export default AdvancedListRecps
