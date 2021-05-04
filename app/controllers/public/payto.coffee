import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isBlank, isEmpty } from '@ember/utils'

import Logger from 'melis-cm-svcs/utils/logger'

PayToController = Controller.extend(

  credentials: service('cm-credentials')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')
  i18n: service()

  queryParams: ['amount', 'info', 'currencyAmount', 'currency']

  editAmount: false

  address: null
  amount: null
  info: null

  recipient: alias('model')

  unit: alias('model.coin')


  currInput: null

  coin: ( ->
    @get('coinsvc.coins')?.findBy('unit', @get('unit'))
  ).property('coin', 'coinsvc.inited', 'coinsvc.coins.[]')


  fmtdAmount: ( ->
    if (amount = @get('amount'))
      @get('coinsvc').formatUnit(@get('coin'), amount)
  ).property('coin.subunit', 'amount')


  setCurrAmount: ( ->

    if (c = @get('currency'))
      @get('currencySvc')?.set('activeCurrency', c)


    if @get('unit') && !isEmpty(@get('coinsvc.coins')) && (a = @get('currencyAmount')) && @get('coin.ticker')

      @get('currencySvc')?.convertFrom(@get('unit'), a)
      @set('amount', @get('currencySvc')?.convertFrom(@get('unit'), a))
  ).observes('currencyAmount', 'currency', 'coinsvc.coins.[]', 'unit', 'coin.ticker').on('init')


  makeEditable: (->
    if @get('amount')
      @set('editAmount', false)
    else
      @set('editAmount', true)
  ).observes('amount').on('init')

  urlAmount: (->
    if amount = @get('amount')
      @get('currencySvc').satoshisToCoin(amount)
  ).property('amount')

  paymentUrl: ( ->
    { urlAmount,
      address } = @getProperties('urlAmount', 'address')

    scheme =
      if @get('coin.scheme') then (@get('coin.scheme') + ':') else ''
    params =
      if urlAmount then "?amount=#{urlAmount}" else ''

    if address
      "#{scheme}#{address}#{params}"

  ).property('model', 'address', 'urlAmount')

  currencyConv: ( ->
    if (amount = @get('amount'))
      @get('coin')?.convertToCurrency(amount)
  ).property('amount', 'coin.value')

  resetOnChange: ( ->
    @setProperties
      error: null
      address: null
  ).observes('model')


  requestAddress: (->
    if (id = @get('model.pubId'))
      @set 'error', null
      @get('cm.api').getPaymentAddressForAccount(id, memo: @get('info'), address: @get('address')).then((res) =>
        @set('address', res)
      ).catch((err) =>
        Logger.error('Error getting payment address: ', err)
        @setProperties
          address: null
          showCode: false
          error: @get('i18n').t('public.payto.error.noaddr')
      )
  )


  actions:
    currencyConfirm: (po)->
      if (i = Math.abs(@get('currencyAmount')))
        a = @get('currencySvc').convertFrom(@get('unit'), i)
        @set('amount', a)

        po.close() if po

    showCode: ->
      @requestAddress()
      false

    changeInfo: (value) ->
      @set 'info', value
      @requestAddress() if @get('address')
      false


    setEditAmount: ->
      @set('editAmount', true) if !@get('editAmount')
      false

    changeAmount: (newValue) ->
      newValue = Math.abs(newValue)
      if newValue
        @setProperties
          editAmount: false
          amount: @get('coinsvc').parseUnit(@get('coin'), newValue)
      else
        @setProperties
          amount:  null

)

export default PayToController
