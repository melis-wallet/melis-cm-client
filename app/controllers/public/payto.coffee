`import Ember from 'ember'`

PayToController = Ember.Controller.extend(

  credentials: Ember.inject.service('cm-credentials')
  currencySvc: Ember.inject.service('cm-currency')
  coinsvc: Ember.inject.service('cm-coin')
  i18n: Ember.inject.service()

  queryParams: ['amount', 'info']

  editAmount: false

  address: null
  amount: null
  info: null

  recipient: Ember.computed.alias('model')

  unit: Ember.computed.alias('model.coin')
  coin: ( ->
    @get('coinsvc.coins')?.findBy('unit', @get('unit'))
  ).property('coin', 'coinsvc.inited')


  fmtdAmount: ( ->
    if (amount = @get('amount'))
      @get('coinsvc').formatUnit(@get('coin'), amount)
  ).property('coin.subunit', 'amount')



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
    amount = @get('urlAmount')
    address = @get('address')

    if address
      "bitcoin:#{address}?amount=#{amount}"

  ).property('model', 'address', 'urlAmount')



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
        Ember.Logger.error('Error getting payment address: ', err)
        @setProperties
          address: null
          showCode: false
          error: @get('i18n').t('public.payto.error.noaddr')
      )
  )


  actions:
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
      if newValue
        @setProperties
          editAmount: false
          amount: @get('coinsvc').parseUnit(@get('coin'), newValue)
      else
        @setProperties
          amount:  null

)

`export default PayToController`
