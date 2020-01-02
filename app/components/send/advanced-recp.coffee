import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, set } from '@ember/object'

import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'

import Logger from 'melis-cm-svcs/utils/logger'


AdvancedRecp = Component.extend(ModelFactory,

  cm: service('cm-session')
  currencySvc: service('cm-currency')
  scanner: service('scanner-provider')
  curr: service('cm-currency')

  account: null
  recipients: null
  recipient: null

  parent: null

  getAmounts: true

  abOpened: false

  currency: alias('currencySvc.currency')
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
        set(@get('recipient'), 'type', 'address')
        set(@get('recipient'), 'value', addr)
        if (amount = get(data, 'queries.amount'))
          scaled = @get('curr').scaleBtc(amount * SATOSHI)
          set(@get('recipient'), 'amount', scaled)
    ).catch((err) ->
      Logger.error "Scanner aborted", err
    )

  canToggleEntireBalance: ( ->
    @get('recipient.entireBalance') || @get('recipient.allowUnconfirmed') || !@get('account.balance.amUnconfirmed')
  ).property('account.balance.amUnconfirmed', 'recipient.entireBalance', 'recipient.allowUnconfirmed')


  watchUnconfirmed: ( ->
    @set('recipient.allowUnconfirmed', @get('parent.allowUnconfirmed'))
    @set('recipient.entireBalance', false)
  ).observes('parent.allowUnconfirmed')

  reset: ->
    @setProperties
      recipient: @createSimpleModel('payment-recipient', account: @get('account'))
      abOpened: false
    @set('recipient.allowUnconfirmed', @get('parent.allowUnconfirmed'))

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
      Logger.info "Adding recp: ", {type: type, value: value, entry: entry}
      @set 'abOpened', false
      if (r = @get('recipient'))
        # do not coalesce into setProperties, setting type clears value
        r.set('type', type)
        r.set('value', value)
        if name = get(entry, 'meta.name')
          r.set('info', "[#{name}]")
        if (cmalias = get(entry, 'meta.alias'))
          r.setMeta('toAlias', cmalias)


)

export default AdvancedRecp
