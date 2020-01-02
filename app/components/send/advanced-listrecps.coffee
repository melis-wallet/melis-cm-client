import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

AdvancedListRecps = Component.extend(

  cm: service('cm-session')

  parent: null
  recipients: null

  account: null

  preparedTx: null
  paymentReady: alias('parent.paymentReady')

  total: alias('parent.totalAmount')
  isEntireBalance: alias('parent.isEntireBalance')


  actions:
    deleteRecipient: (r) ->
      @sendAction('on-delete', r)

)

export default AdvancedListRecps
