`import Ember from 'ember'`
`import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'`

AdvancedRecp = Ember.Component.extend(ModelFactory,

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')
  scanner: Ember.inject.service('scanner-provider')
  curr: Ember.inject.service('cm-currency')

  account: null
  recipients: null
  recipient: null

  parent: null

  getAmounts: true

  abOpened: false

  currency: Ember.computed.alias('cm.globalCurrency')
  currencies: ( ->
    curr = @get('currency')
    unit = @get('account.subunit.symbol')

    [ {id: unit, value: unit}
      {id: curr, value: curr}
    ]

  ).property('currency', 'account.subunit')

  setup: (->
    @reset()
    @get('recipient.value')
  ).on('init').observes('account')

  valueChanged: (->
    @sendAction('on-change', @get('recipient'))
  ).observes('recipient.value')


  #
  #
  #
  openScanner: ->
    @get('scanner').independentScan().then((data) =>
      if (addr = @get('scanner').getAddressFromData(data))
        Ember.set(@get('recipient'), 'type', 'address')
        Ember.set(@get('recipient'), 'value', addr)
        if (amount = Ember.get(data, 'queries.amount'))
          scaled = @get('curr').scaleBtc(amount * SATOSHI)
          Ember.set(@get('recipient'), 'amount', scaled)
    ).catch((err) ->
      Ember.Logger.error "Scanner aborted", err
    )


  reset: ->
    @setProperties
      recipient: @createSimpleModel('payment-recipient', account: @get('account'))
      abOpened: false

  actions:
    submitRecipient: ->
      if @get('recipient.isValid')
        @sendAction('on-add', @get('recipient'))
        @reset()


    toggleEntireBalance: ->
      @toggleProperty('recipient.entireBalance')

    close: ->
      @reset()

    openScanner: ->
      @openScanner()

    openAb: ->
      @set 'abOpened', true

    closeAb: ->
      @set 'abOpened', false

    addRecipientFromAb: (type, value, entry) ->
      Ember.Logger.info "Adding recp: ", {type: type, value: value, entry: entry}
      @set 'abOpened', false
      if (r = @get('recipient'))
        # do not coalesce into setProperties, setting type clears value
        r.set('type', type)
        r.set('value', value)
        if name = Ember.get(entry, 'meta.name')
          r.set('info', "[#{name}]")
        if (alias = Ember.get(entry, 'meta.alias'))
          r.setMeta('toAlias', alias)


)

`export default AdvancedRecp`
