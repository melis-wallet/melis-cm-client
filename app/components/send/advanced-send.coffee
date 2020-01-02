import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'
import { get, set, computed } from '@ember/object'
import { isEmpty } from '@ember/utils'
import { A } from '@ember/array'
import RSVP from 'rsvp'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


AdvancedSend = Component.extend(Alertable,


  cm: service('cm-session')
  aa: service('aa-provider')
  ptxsvc: service('cm-ptxs')
  accInfo: service('cm-account-info')


  account: null
  preparedTx: null


  # all the recipients for the current payment
  recipients: null

  # let the server do the inputs
  autoSource: true

  # let the server do the fees
  autoFees: true

  # fees multiplier in auto mode
  feesMult: 1.0
  feesLabel: 'tx.fees.normal'

  # fees per bytes in manual mode
  feesPerByte: null

  feesEstData: null
  feesEstValuePerByte: null

  # actual fees
  fees: alias('preparedTx.cmo.fees')

  # other options
  optRBF: true
  allowUnconfirmed: false


  sources: null
  sourcesAmount: null

  coin: alias('account.unit')

  #state
  addMode: true

  paymentReady: notEmpty('preparedTx')

  #
  prepareOps: taskGroup().enqueue()
  confirmOps: taskGroup().enqueue()

  feeEstimate:( ->
    acct = @get('account')
    sources = @get('sources.length') || 1
    dsts = @get('sources.length') + 1
    size = @get('accInfo').estimateTxSizeFor(acct, sources, dsts)

    ((if @get('autoFees')
      @get('feesEstValuePerByte')
    else
      @get('feesPerByte')
    ) * size)
  ).property('feesEstValuePerByte', 'feesPerByte', 'account', 'sources.[]', 'recipients.[]', 'autoFees')


  autoRemainder: computed.not('remainderAddr')

  computedRemainder: ( ->
    if !@get('remainderAddr') && @get('sourcesAmount')
      @get('sourcesAmount') - @get('totalAmount')
  ).property('remainderAddr', 'sourcesAmount', 'totalAmount')

  valid: ( ->
    !@get('insuffSources') && !isEmpty(@get('recipients'))
  ).property('insuffSources', 'recipients.[]')

  totalAmount: ( ->
    recipients = @get('recipients')
    recipients.reduce ((sum, row) ->
        sum += get(row, 'fullAmount')
      ), 0
  ).property('recipients.[]')


  spendingAmount: ( ->
    if @get('isEntireBalance')
      if @get('autoSource')
        @get('account.amSummary')
      else @get('sourcesAmount')
    else
      @get('totalAmount')
  ).property('totalAmount', 'autoSource', 'isEntireBalance', 'sourcesAmount', 'account.amSummary')


  #
  #
  #
  signingProgress: alias('preparedTx.signingProgress')
  signing: alias('preparedTx.signing')


  accountChanged: ( ->
    console.error "acct changed"
    @setProperties
      ptx: null
      feeEstimate: null
      feesEstData: null
      feesEstValuePerByte: null
      feesPerByte: null
  ).observes('account')

  coinChanged: ( ->
    @setProperties
      optRBF: @get('coin.features.rbf')
      allowUnconfirmed: @get('coin.features.defaultUncf') || false
      feesEstData: null
      feesEstValuePerByte: null
  ).observes('coin.unit').on('init')

  setup: (->
    @getProperties('account', 'coin')

    if isEmpty(@get('feesEstData'))
      @get('getFeeEstimate').perform()
  ).on('init')

  accountChanged: ( -> @reset()).on('init').observes('account')

  showAdd: alias('addMode')

  showSummaryPanel: ( ->
    !isEmpty(@get('recipients')) || (!@get('autoSource') && !isEmpty(@get('sources')))
  ).property('recipients.[]', 'sources.[]', 'autoSource')

  remainderAddr: ( ->
    (recipients = @get('recipients')) && recipients.findBy('entireBalance', true)
  ).property('recipients.@each.entireBalance')

  # one of the recipients gets the entire balance (or selected inputs)
  isEntireBalance: ( ->
    (recipients = @get('recipients')) && recipients.any((item) -> item.get('entireBalance'))
  ).property('recipients.@each.entireBalance')

  # at least one of the recipients DOES not get the entire balance
  hasNormalDests: ( ->
    (recipients = @get('recipients')) && recipients.any((item) -> !item.get('entireBalance'))
  ).property('recipients.@each.entireBalance')

  canAdd: (-> !@get('isEntireBalance')).property('isEntireBalance')

  insuffSources: (-> !@get('autoSource') && (@get('sourcesAmount') <= @get('totalAmount'))).property('totalAmount', 'sourcesAmount', 'autoSource')


  getFeeEstimate: task( ->
    return unless (coin = @get('coin.unit'))

    try
      provs = yield @get('cm.api').feeApi.getProviderNames(coin)
      Logger.debug('Fee provs:', provs)
      if provs
        p = provs[Math.floor(Math.random() * provs.length)]
        val = yield @get('cm.api').feeApi.getFeesByProvider(coin, p)()
        Logger.debug('Fee est:', val)
        if val
          @set('feesEstData', val)
          value = get(val, 'fastestFee')
          @set('feesEstValuePerByte', value) if value
          @sendAction('on-change', value)

    catch error
       Logger.error('Unable to hit fees: ', error)
  )

  backToAutoSource: ( -> @set('sources', A()) if @get('autoSource')).observes('autoSource')

  reset: ->
    @closeAllAlerts()
    @setProperties
      preparedTx: null
      recipients: A()
      addMode: true
      sources: null
      autoSource: true
      autoFees: true



  #
  #
  #
  cancelTx: task((ptx) ->
    try
      yield @get('ptxsvc').ptxCancel(ptx)
    catch err
      @alertWarning "#{@get('i18n').t('paysend.err.occurred', error: err.msg)}", true
  ).group('confirmOps')



  #
  #
  #
  cancelPayment: task(->
    if ptx = @get('preparedTx')
      try
        yield @get('cancelTx').perform(ptx)
        @set 'preparedTx', null
        @reset()
      catch err
        Logger.error '[SEND] cancelPayment error', err
  )


  #
  #
  addRecipient: (recipient) ->
    @get('recipients').pushObject(recipient)
    @set('addMode', false)


  #
  #
  #
  autoProposePayment: task( ->
    if @get('preparedTx.isMultisig')
      try
        yield @get('proposePayment').perform()
        @clearState()
      catch err
        Logger.error '[SEND] proposePayment error', err
  )

  #
  #
  #
  proposePayment: task( ->
    { ptxsvc,
      preparedTx } = @getProperties('ptxsvc', 'preparedTx')

    if preparedTx && !preparedTx.get('hasFieldsSignature')
      try
        res = yield ptxsvc.ptxPropose(preparedTx)
      catch err
        Logger.error('error: ', err)
        @alertWarning "#{@get('i18n').t('paysend.err.occurred', error: err.msg)}", true
  ).group('confirmOps')



  #
  #
  preparePayment: task((recipients, options) ->
    { cm,
      recipients
      ptxsvc,
      autoFees,
      autoSource,
      sources,
      autoRemainder,
      optRBF,
      allowUnconfirmed
      feesMult,
      feesPerByte,
      feesEstValuePerByte} = @getProperties('cm','recipients', 'ptxsvc', 'autoFees',
                                 'autoSource', 'sources', 'autoRemainder', 'optRBF', 'allowUnconfirmed', 'feesMult', 'feesPerByte', 'feesEstValuePerByte')

    plainRecs = recipients.map((r) -> r.toCmo())

    isEntireBalance = recipients.any((item) -> item.get('entireBalance'))

    unspents =
      if @get('autoSource')
        null
      else
        sources.map((i) -> {hash: i.tx, n: i.n })


    params =
      selectAllUnspents: (isEntireBalance && isEmpty(unspents))
      unspents: unspents
      disableRbf: optRBF,
      allowUnconfirmed: allowUnconfirmed,

    if autoFees
      params.feeMultiplier = feesMult || 1.0
    else
      params.satoshisPerByte = feesPerByte || feesEstValuePerByte

    if !isEmpty(recipients)
      @closeAllAlerts()

      op = (tfa) ->
        params.tfa = tfa.payload
        cm.payPrepare(plainRecs, params)
      try
        state = yield @get('aa').tfaAuth(op, @get('i18n').t('paysend.prompts.prepare'))
        ptx = @get('ptxsvc').ptxFromState(state, @get('cm.currentAccount'))
        @set 'preparedTx', ptx
        unless ptx.get('isMultisig')
          return yield @get('proposePayment').perform()
      catch err
        Logger.error('error: ', err)
        if err.ex is 'CmInsufficientFundsException'
          @alertWarning "<b>#{@get('i18n').t('paysend.err.prepare-fail')}:</b> #{@get('i18n').t('paysend.err.no-funds')}", true
        else
          @alertWarning @get('i18n').t('paysend.err.occurred', error: err.msg), true
  ).group('prepareOps')


  #
  #
  #
  confirmPayment: task( ->
    { ptxsvc,
      preparedTx } = @getProperties('ptxsvc', 'preparedTx')


    if preparedTx && preparedTx.get('hasFieldsSignature')
      try
        res = yield ptxsvc.ptxSign(preparedTx)
        if @get('preparedTx.cosignRequired')
          @alertSuccess  "<b>#{@get('i18n').t('paysend.success')}:</b> #{@get('i18n').t('paysend.tx-success')}", true
        else
          @alertSuccess  "<b>#{@get('i18n').t('paysend.success')}:</b> #{@get('i18n').t('paysend.tx-done')}", true
        @reset()
      catch err
        @alertWarning @get('i18n').t('paysend.err.occurred', error: @get('i18n').t_ex(err)), true
    else
      Logger.error '[SEND] prepared has no fields signatures.', preparedTx, preparedTx.get('hasFieldsSignature')
      RSVP.reject('invalid prepared tx')
  ).group('confirmOps')



  #
  #
  #
  autoProposePayment: task( ->
    if @get('preparedTx.isMultisig')
      try
        yield @get('proposePayment').perform()
        @reset()
      catch err
        Logger.error '[SEND] proposePayment error', err
  )

  #
  #
  #
  autoConfirmPayment: task( ->
    if ptx = @get('preparedTx')
      try
        if ptx.get('isMultisig')
          yield @get('proposePayment').perform()
          yield @get('confirmPayment').perform()
        else
          yield @get('confirmPayment').perform()
      catch err
        Logger.error '[SEND] proposePayment error', err
  )

  actions:
    feesChanged: (mult, value) ->
      @setProperties
        feesMult: mult
        feesLabel: get(value, 'label')

    preparePayment: ->
      if @get('valid')
        @get('preparePayment').perform()

    cancelTx: (tx) ->
      if tx ?= @get('preparedTx')
        @get('cancelTx').perform(tx)

    cancelPayment: ->
      @get('cancelPayment').perform()

    proposePayment: ->
      @get('autoProposePayment').perform()

    confirmPayment: ->
      @get('autoConfirmPayment').perform()

    resetPayment: ->
      @reset()

    reEstimateFees: ->
      @get('getFeeEstimate').perform()

    addRecipient: (recp) ->
      @addRecipient(recp)

    deleteRecipient: (recp) ->
      r = @get('recipients')
      r.removeObject(recp)
      @set('addMode', true) if isEmpty(r)

    selectSources: (amount, srcs) ->
      @setProperties
        sourcesAmount: amount
        sources: srcs

    toggleAdd: ->
      @set('addMode', true)

)

export default AdvancedSend
