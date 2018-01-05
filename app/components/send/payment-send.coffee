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

  coin: Ember.computed.alias('cm.currentAccount.unit')

  optRBF: true
  allowUnconfirmed: false

  isEntireBalance: ( ->
    (@get('currentRecipient.entireBalance') || @get('recipients').any((item) -> item.get('entireBalance')))
  ).property('recipients.@each.entireBalance', 'currentRecipient.entireBalance')

  canToggleEntireBalance: ( ->
    @get('currentRecipient.entireBalance') || !@get('cm.currentAccount.balance.amUnconfirmed')
  ).property('cm.currentAccount.balance.amUnconfirmed', 'currentRecipient.entireBalance')

  canAddRecipient: ( ->
    @get('currentRecipient.isValid') && !@get('isEntireBalance')
  ).property('isEntireBalance', 'currentRecipient.isValid')

  # at least one of the recipients DOES not get the entire balance
  hasNormalDests: ( ->
    (recipients = @get('recipients')) && recipients.any((item) -> !item.get('entireBalance'))
  ).property('recipients.@each.entireBalance')

  feesMult: 1.0

  currencies: ( ->
    curr = @get('currency')
    unit = @get('cm.currentAccount.subunit.symbol')

    [ {id: unit, value: unit}
      {id: curr, value: curr}
    ]

  ).property('currency', 'cm.currentAccount.subunit')

  fees: Ember.computed.alias('preparedTx.cmo.fees')

  computedFees: (->
    @getWithDefault('fees', 0.0)
  ).property('preparedTx')

  abClose: ( -> @set('abOpened', false)).observes('cm.currentAccount')

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

  coinChanged: ( ->
    @set('optRBF', @get('coin.features.rbf'))
  ).observes('coin').on('init')

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
