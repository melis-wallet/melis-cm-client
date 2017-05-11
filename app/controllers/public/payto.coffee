`import Ember from 'ember'`
`import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'`

PayToController = Ember.Controller.extend(ModelFactory,

  credentials: Ember.inject.service('cm-credentials')
  currencySvc: Ember.inject.service('cm-currency')
  i18n: Ember.inject.service()

  queryParams: ['amount', 'info']

  editAmount: false

  address: null
  recipient: null

  makeEditable: (->
    if @get('amount')
      @set('editAmount', false)
    else
      @set('editAmount', true)
  ).observes('amount').on('init')

  urlAmount: (->
    if amount = @get('recipient.amount')
      @get('currencySvc').satoshisToBtc(amount)
  ).property('recipient.amount')

  paymentUrl: ( ->
    amount = @get('urlAmount')
    address = @get('recipient.address')

    if address
      "bitcoin:#{address}?amount=#{amount}"

  ).property('recipient', 'recipient.address', 'urlAmount')


  setRecipientChange: ( ->
    if model = @get('model')
      n =  @createSimpleModel('payment-recipient',
        address: @get('address')
        pubId: @get('model.pubId')
        amount: parseInt(@get('amount'))
        currency: @get('currencySvc.currency')
        info: @get('info')
      )

      @set('recipient', n)
  ).observes('amount', 'info', 'model', 'address')


  resetOnChange: ( ->
    @setProperties
      error: null
      address: null
  ).observes('model')


  requestAddress: (->
    if (id = @get('model.pubId'))
      @set 'error', null
      @get('cm.api').getPaymentAddressForAccount(id, @get('recipient.info')).then((res) =>
        console.log("GOT: ", res)
        @set('address', res)
      ).catch((err) =>
        Ember.Logger.error('Error getting payment address: ', err)
        @setProperties
          address: null
          showCode: false
          error: @get('i18n').t('public.payto.error.noaddr')
      )
  )


  setup: ( ->
    @set('recipient', @createSimpleModel('payment-recipient'))
  ).on('init')


  actions:
    showCode: ->
      @requestAddress()
      false

    changeInfo: (value) ->
      @set 'info', value


    setEditAmount: ->
      @set('editAmount', true) if !@get('editAmount')
      false

    changeAmount: (newValue) ->
      if newValue
        @setProperties
          #editAmount: false
          amount:  (newValue || 0.0) * @get('currencySvc.btcDivider')

)

`export default PayToController`
