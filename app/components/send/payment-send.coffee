`import Ember from 'ember'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`

PaymentSend = Ember.Component.extend(Alertable,

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')

  recipients: null
  currentRecipient: null

  preparedTx: null
  preparedState: Ember.computed.alias('preparedTx.state')
  paymentReady: Ember.computed.notEmpty('preparedTx')

  showSummary: false

  addMore: false
  moreInfo: false

  abOpened: false

  hasRecipients: Ember.computed.notEmpty('recipients')
  currency: Ember.computed.alias('cm.globalCurrency')

  optRBF: true
  allowUnconfirmed: false

  isEntireBalance: ( ->
    (@get('currentRecipient.entireBalance') || @get('recipients').any((item) -> item.get('entireBalance')))
  ).property('recipients.@each.entireBalance', 'currentRecipient.entireBalance')

  blockEntireBalance: ( ->
    @get('cm.currentAccount.balance.amUnconfirmed') || (!@get('isEntireBalance') && !Ember.isEmpty(@get('recipients')))
  ).property('cm.currentAccount.balance.amUnconfirmed', 'isEntireBalance', 'recipients.[]')


  feesMult: 1.0

  currencies: ( ->
    curr = @get('currency')
    btc = @get('cm.btcUnit')

    [ {id: btc, value: btc}
      {id: curr, value: @get('currency')}
    ]

  ).property('currency', 'cm.btcUnit')

  fees: Ember.computed.alias('preparedTx.cmo.fees')

  computedFees: (->
    @getWithDefault('fees', 0.0)
  ).property('preparedTx')


  total: (->
    @get('amount') + @get('computedFees')
  ).property('amount', 'computedFees')

  amount: ( ->
    if @get('preparedTx')
      recipients = @get('preparedTx.cmo.recipients')
      recipients.reduce ((sum, row) ->
          sum += Ember.get(row, 'amount')
        ), 0
    else
      recipients = @get('recipients')
      recipients.reduce ((sum, row) ->
          sum += Ember.get(row, 'fullAmount')
        ), 0
  ).property('recipients.[]', 'preparedTx')

  actualRecipients: Ember.computed.alias('preparedTx.cmo.recipients')

  successfulAdd: (->
    @setProperties
      addMore: false
      moreInfo: false
  ).observes('recipients.[]')

  watchUnconfirmed: ( ->
    @set('currentRecipient.allowUnconfirmed', @get('allowUnconfirmed'))
  ).observes('allowUnconfirmed')


  actions:

    toggleEntireBalance: ->
      @toggleProperty('currentRecipient.entireBalance')

    openAb: ->
      @set 'abOpened', true

    closeAb: ->
      @set 'abOpened', false

    submitRecipient: ->
      if (recipient = @get('currentRecipient')) && recipient.get('isValid')
        @sendAction('on-submit', recipient)

    submitRecipientComplete: ->
      if (recipient = @get('currentRecipient')) && recipient.get('isValid')
        @sendAction('on-submit-complete', recipient, @getProperties('feesMult', 'optRBF', 'allowUnconfirmed', 'isEntireBalance'))
      else if Ember.isEmpty(recipient.get('address'))
        @sendAction('on-complete', @get('recipients'))

    submitComplete: ->
      if recipients = @get('recipients')
        @sendAction('on-complete', recipients, @getProperties('feesMult', 'optRBF', 'allowUnconfirmed', 'isEntireBalance'))

    deleteRecipient: (recipient) ->
      @get('recipients').removeObject(recipient)

    addRecipientFromAb: (type, value, entry) ->
      Ember.Logger.info "Adding recp: ", {type: type, value: value, entry: entry}
      @set 'abOpened', false
      if (r = @get('currentRecipient'))
        # do not coalesce into setProperties, setting type clears value
        r.set('type', type)
        r.set('value', value)
        if name = Ember.get(entry, 'meta.name')
          r.set('info', "[#{name}]")
        if (alias = Ember.get(entry, 'meta.alias'))
          r.setMeta('toAlias', alias)

    cancelForm: ->

    cancelPayment: ->
      @setProperties
        recipients: Ember.A()
        optRBF: true
        feesMult: 1.0
        allowUnconfirmed: false

      @sendAction('on-cancel-payment')

    proposeTx: ->
      if @get('paymentReady')
        @sendAction('on-propose')

    confirmTx: ->
      if @get('paymentReady')
        @sendAction('on-confirm')

    cancelTx: ->
      if @get('paymentReady')
        @sendAction('on-cancel')


    openScanner: ->
      @sendAction('on-scan')
)

`export default PaymentSend`
