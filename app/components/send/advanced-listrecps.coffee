`import Ember from 'ember'`

AdvancedListRecps = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  parent: null
  recipients: null

  account: null

  preparedTx: null
  paymentReady: Ember.computed.alias('parent.paymentReady')

  total: Ember.computed.alias('parent.totalAmount')
  isEntireBalance: Ember.computed.alias('parent.isEntireBalance')


  actions:
    deleteRecipient: (r) ->
      @sendAction('on-delete', r)

)

`export default AdvancedListRecps`
