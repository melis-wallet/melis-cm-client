import { computed } from '@ember/object'
import { inject as service } from '@ember/service'
import { alias, bool, equal } from '@ember/object/computed'
import { get, set } from '@ember/object'
import { A } from '@ember/array'
import { isBlank } from '@ember/utils'

import Model from './cm-model'
import formatMoney from "accounting/format-money"
import { mergeProperty } from 'melis-cm-svcs/utils/misc'
import { translationMacro as t } from "ember-i18n"
import { validator, buildValidations } from 'ember-cp-validations'

import Logger from 'melis-cm-svcs/utils/logger'


INSUFF_FUNDS = 'paysend.form.insuff-funds'

Validations = buildValidations(
  value: [
    validator('presence', presence: true)
    validator('coin-address', disabled: computed.not('model.isAddress'), coin: alias('model.account.coin'), allowURI: true)
    validator('melis-pubid', disabled: computed.not('model.isPubid'))
    validator('melis-alias', disabled: computed.not('model.isAlias'))
  ]

  amount: [
    validator('presence', presence: true, disabled: bool('model.entireBalance'))
    validator('number', positive: true, gt: 0, allowString: true, allowBlank: true)
    validator('inline' , validate: ((value, options, model, attribute) ->

      amount = model.get('fullAmount')

      if model.get('allowUnconfirmed') && (amount <= (model.get('account.balance.amAvailable') + model.get('account.balance.amUnconfirmed')))
        return true
      else if amount > model.get('account.balance.amAvailable')
        return model.get('i18n').t(INSUFF_FUNDS).toString()
      else
        true
    ), dependentKeys: ['model.allowUnconfirmed', 'model.account.balance.amAvailable', 'model.account.balance.amUnconfirmed'])
  ]
)

PaymentRecipient = Model.extend(Validations, 

  cm: service('cm-session')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')
  i18n: service('i18n')

  account: null
  type: 'address'

  value: null

  amount: null

  info: null
  labels: null
  meta: null

  currency: null
  currencyValue: alias('account.unit.value')

  entireBalance: false
  allowUnconfirmed: false

  isAddress: equal('type', 'address')
  isCm: equal('type', 'cm')
  isAccount: equal('type', 'account')

  isValid: alias('validations.isValid')

  value: computed(
    get: (key) ->
      return @_value

    set: (key, val) ->
      if @isAddress
        return @set('_value', val?.trim())
      else
        return @set('_value', val)
  )


  currencyChanged: (->
    @set('meta',  {}) if !@get('meta')
    meta = @get('meta')

    if @get('currencyIsCrypto')
      data = {currency: @get('currencySvc.currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencyValue') }
    else
      data = {currency: @get('currency'), amount: @get('amountInTickerCurrency'), rate: @get('currencyValue'), native: true }
    set(meta, 'currencyData', data)
  ).observes('currency', 'amount', 'account.unit.value')


  info: computed('meta',
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

  btcUnitChanged: ( -> @set('amount', null)).observes('account.unit')

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
        cmo.address = @get('coinsvc').addressFromUri(@get('value'), @get('account.coin'))
      when 'cm'
        cmo.pubId = @get('value.alias') || @get('value.pubId')
      when 'account'
        cmo.pubId = @get('value.cmo.pubId')

    return cmo


  setup: ( ->
    @setProperties
      meta: {}
      labels: A()
    Logger.warn("[recp] Account is not defined") if isBlank(@get('account'))
  ).on('init')
)

export default PaymentRecipient
