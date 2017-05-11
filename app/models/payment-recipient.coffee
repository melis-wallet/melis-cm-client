`import Ember from 'ember'`
`import Model from './cm-model'`
`import formatMoney from "accounting/format-money"`
`import { mergeProperty } from 'melis-cm-svcs/utils/misc'`
'import { translationMacro as t } from "ember-i18n"'
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

INSUFF_FUNDS = 'paysend.form.insuff-funds'

Validations = buildValidations(
  value: [
    validator('presence', presence: true)
    validator('bitcoin-address', disabled: Ember.computed.not('model.isAddress'))
    validator('melis-pubid', disabled: Ember.computed.not('model.isPubid'))
    validator('melis-alias', disabled: Ember.computed.not('model.isAlias'))
  ]

  amount: [
    validator('presence', presence: true, disabled: Ember.computed.bool('model.entireBalance'))
    validator('number', positive: true, allowString: true, allowBlank: true)
    validator(((value, options, model, attribute) ->
      return true if model.get('allowUnconfirmed')
      amount = model.get('fullAmount')
      if amount > model.get('cm.currentAccount.balance.amAvailable')
        return model.get('i18n').t(INSUFF_FUNDS).toString()
      else
        true
    ), dependentKeys: ['model.allowUnconfirmed', 'model.cm.currentAccount.balance.amAvailable'])
  ]
)

PaymentRecipient = Model.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')
  i18n: Ember.inject.service('i18n')

  type: 'address'

  value: null

  amount: null
  fullAmount: false

  info: null
  labels: null
  meta: null

  currency: null
  rate: null

  entireBalance: false
  allowUnconfirmed: false

  isAddress: Ember.computed.equal('type', 'address')
  isCm: Ember.computed.equal('type', 'cm')
  isAccount: Ember.computed.equal('type', 'account')

  currencyChanged: (->
    meta = @get('meta')

    if @get('currencyIsBtc')
      data = {currency: @get('currencySvc.currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencySvc.value') }
    else
      data = {currency: @get('currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencySvc.value'), native: true }
    Ember.set(meta, 'currencyData', data)
  ).observes('currency', 'amount')


  info: Ember.computed('meta',
    get: (key) ->
      @get('meta.info')

    set: (key, val) ->
      @setMeta('info', val)
  )

  currencyIsBtc: (->
    (@get('currency') == @get('cm.btcUnit'))
  ).property('currency', 'cm.btcUnit')

  amountInBtcFmt: ( ->
    @get('currencySvc').formatBtc(@get('fullAmount'))
  ).property('fullAmount')


  setMeta: (key, value) ->
    @set('meta',  {}) if !@get('meta')
    v = {}; v[key] = value
    mergeProperty(this, 'meta', v)
    value

  fullAmount: ( ->
    { amount,
      currency,
      currencySvc } = @getProperties('amount', 'currency', 'currencySvc')

    return 0 unless amount
    return currencySvc.parseBtc(amount) if (currency == @get('cm.btcUnit'))

    tickerCurrency = @get('currencySvc.currency')

    if currency == tickerCurrency
      currencySvc.convertFrom(amount)
    else
      # fixme! fetch the current value through an api?
      throw "no value for currency"
  ).property('currency', 'amount', 'currencySvc.value', 'cm.btcUnit')


  amountInTickerCurrency: ( ->
    { amount,
      currency,
      currencySvc } = @getProperties('amount', 'currency', 'currencySvc')

    return amount if (currency != @get('cm.btcUnit'))
    currencySvc.convertTo(currencySvc.parseBtc(amount))
  ).property('currency', 'amount', 'currencySvc.value', 'cm.btcUnit')


  amountInCurrFmt: (-> formatMoney(@get('amountInTickerCurrency')) ).property('amountInTickerCurrency')

  amountsChanged: ( -> @validate() ).observes('cm.currentAccount.amSummary', 'currency')

  typeChanged: ( -> @set('value', null) ).observes('type')

  btcUnitChanged: ( -> @set('amount', null)).observes('cm.btcUnit')

  resetUnit: ( -> @set 'currency', @get('cm.btcUnit') ).observes('cm.btcUnit').on('init')

  toCmo: ->
    { type,
      fullAmount,
      entireBalance } = @getProperties('type', 'fullAmount', 'entireBalance')


    cmo = @getProperties('meta', 'labels')
    if entireBalance
      cmo.isRemainder = true
      cmo.amount = 0
    else
      cmo.amount = fullAmount

    switch type
      when 'address'
        cmo.address = @get('value')
      when 'cm'
        cmo.pubId = @get('value.alias') || @get('value.pubId')
      when 'account'
        cmo.pubId = @get('value.cmo.pubId')

    return cmo


  setup: ( ->
    @setProperties
      meta: {}
      labels: Ember.A()
  ).on('init')
)

`export default PaymentRecipient`
