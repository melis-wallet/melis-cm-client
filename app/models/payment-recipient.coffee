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
    validator('number', positive: true, gt: 0, allowString: true, allowBlank: true)
    validator(((value, options, model, attribute) ->
      return true if model.get('allowUnconfirmed')
      amount = model.get('fullAmount')
      if amount > model.get('account.balance.amAvailable')
        return model.get('i18n').t(INSUFF_FUNDS).toString()
      else
        true
    ), dependentKeys: ['model.allowUnconfirmed', 'model.account.balance.amAvailable'])
  ]
)

PaymentRecipient = Model.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')
  coinsvc: Ember.inject.service('cm-coin')
  i18n: Ember.inject.service('i18n')

  account: null
  type: 'address'

  value: null

  amount: null

  info: null
  labels: null
  meta: null

  currency: null
  currencyValue: Ember.computed.alias('account.unit.value')

  entireBalance: false
  allowUnconfirmed: false

  isAddress: Ember.computed.equal('type', 'address')
  isCm: Ember.computed.equal('type', 'cm')
  isAccount: Ember.computed.equal('type', 'account')



  currencyChanged: (->
    meta = @get('meta')

    if @get('currencyIsCrypto')
      data = {currency: @get('currencySvc.currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencyValue') }
    else
      data = {currency: @get('currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencyValue'), native: true }
    Ember.set(meta, 'currencyData', data)
  ).observes('currency', 'amount', 'account.unit.value')


  info: Ember.computed('meta',
    get: (key) ->
      @get('meta.info')

    set: (key, val) ->
      @setMeta('info', val)
  )

  currencyIsCrypto: (->
    (@get('currency') == @get('account.subunit.id'))
  ).property('currency', 'account.subunit.id')

  amountInCryptoUnit: ( ->
    @get('coinsvc').formatUnit(@get('account'), @get('fullAmount'))
  ).property('fullAmount')


  setMeta: (key, value) ->
    @set('meta',  {}) if !@get('meta')
    v = {}; v[key] = value
    mergeProperty(this, 'meta', v)
    value

  fullAmount: ( ->
    { amount,
      account,
      currency,
      currencySvc,
      coinsvc } = @getProperties('amount', 'account', 'currency', 'currencySvc', 'coinsvc')


    return 0 unless amount
    return coinsvc.parseUnit(account, amount) if @get('currencyIsCrypto')

    tickerCurrency = @get('currencySvc.currency')

    if currency == tickerCurrency
      @get('account.unit')?.convertFromCurrency(amount)
    else
      0 # change this, temp fix for cash not having a value
      # fixme! fetch the current value through an api?
      #throw "no value for currency"
  ).property('currency', 'amount', 'currencyValue', 'account.subunit')


  amountInTickerCurrency: ( ->
    { amount,
      account,
      currency,
      currencySvc,
      coinsvc } = @getProperties('amount', 'account', 'currency', 'currencySvc', 'coinsvc')

    return amount unless @get('currencyIsCrypto')
    @get('account.unit')?.convertToCurrency(coinsvc.parseUnit(account, amount))
  ).property('currency', 'amount', 'currencyValue', 'account.subunit')


  amountInCurrFmt: (-> formatMoney(@get('amountInTickerCurrency')) ).property('amountInTickerCurrency')

  amountsChanged: ( -> @validate() ).observes('account.amSummary', 'currency')

  typeChanged: ( -> @set('value', null) ).observes('type')

  btcUnitChanged: ( -> @set('amount', null)).observes('cm.btcUnit')

  resetUnit: ( -> @set 'currency', @get('account.subunit.id') ).observes('account.subunit').on('init')

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
    Ember.Logger.warn("[recp] Account is not defined") if Ember.isBlank(@get('account'))
  ).on('init')
)

`export default PaymentRecipient`
