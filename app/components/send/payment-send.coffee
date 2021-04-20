import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'
import { get, set } from '@ember/object'
import { isEmpty } from '@ember/utils'
import { A } from '@ember/array'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'

import Logger from 'melis-cm-svcs/utils/logger'


PaymentSend = Component.extend(Alertable,

  cm: service('cm-session')
  currencySvc: service('cm-currency')

  recipients: null
  currentRecipient: null

  preparedTx: null
  preparedState: alias('preparedTx.state')
  paymentReady: notEmpty('preparedTx')

  showSummary: false

  addMore: false
  moreInfo: false

  abOpened: false

  hasRecipients: notEmpty('recipients')
  currency: alias('currencySvc.currency')

  coin: alias('cm.currentAccount.unit')

  optRBF: true
  allowUnconfirmed: false

  isEntireBalance: ( ->
    (@get('currentRecipient.entireBalance') || @get('recipients').any((item) -> item.get('entireBalance')))
  ).property('recipients.@each.entireBalance', 'currentRecipient.entireBalance')

  canToggleEntireBalance: ( ->
    @get('currentRecipient.entireBalance') || @get('allowUnconfirmed') || !@get('cm.currentAccount.balance.amUnconfirmed')
  ).property('cm.currentAccount.balance.amUnconfirmed', 'currentRecipient.entireBalance', 'allowUnconfirmed')

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

    [ unit, curr ]

  ).property('currency', 'cm.currentAccount.subunit')

  fees: alias('preparedTx.cmo.fees')

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
          sum += get(row, 'amount')
        ), 0
    else
      recipients = @get('recipients')
      recipients.reduce ((sum, row) ->
          sum += get(row, 'fullAmount')
        ), 0
  ).property('recipients.[]', 'preparedTx')

  actualRecipients: alias('preparedTx.cmo.recipients')

  successfulAdd: (->
    @setProperties
      addMore: false
      moreInfo: false
  ).observes('recipients.[]')

  watchUnconfirmed: ( ->
    @set('currentRecipient.allowUnconfirmed', @get('allowUnconfirmed'))
    @set('currentRecipient.entireBalance', false)
  ).observes('allowUnconfirmed')

  rcptChanged: ( ->
    @setProperties
      optRBF: @get('coin.features.rbf')
      allowUnconfirmed: @get('coin.features.defaultUncf') || false
    @set('currentRecipient.allowUnconfirmed', @get('allowUnconfirmed'))
  ).observes('coin', 'currentRecipient').on('init')

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
      else if isEmpty(recipient.get('address'))
        @sendAction('on-complete', @get('recipients'))

    submitComplete: ->
      if recipients = @get('recipients')
        @sendAction('on-complete', recipients, @getProperties('feesMult', 'optRBF', 'allowUnconfirmed', 'isEntireBalance'))

    deleteRecipient: (recipient) ->
      @get('recipients').removeObject(recipient)

    addRecipientFromAb: (type, value, entry) ->
      Logger.info "Adding recp: ", {type: type, value: value, entry: entry}
      @set 'abOpened', false
      if (r = @get('currentRecipient'))
        # do not coalesce into setProperties, setting type clears value
        r.set('type', type)
        r.set('value', value)
        if name = get(entry, 'meta.name')
          r.set('info', "[#{name}]")
        if (cmalias = get(entry, 'meta.alias'))
          r.setMeta('toAlias', cmalias)

    cancelForm: ->

    cancelPayment: ->
      @setProperties
        recipients: A()
        optRBF: true
        feesMult: 1.0
        allowUnconfirmed: @get('coin.features.defaultUncf') || false
      @set('currentRecipient.allowUnconfirmed', @get('allowUnconfirmed'))

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

export default PaymentSend
