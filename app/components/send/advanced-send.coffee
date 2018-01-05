`import Ember from 'ember'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`
`import { task, taskGroup } from 'ember-concurrency'`

AdvancedSend = Ember.Component.extend(Alertable,


  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')
  ptxsvc: Ember.inject.service('cm-ptxs')
  accInfo: Ember.inject.service('cm-account-info')


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
  fees: Ember.computed.alias('preparedTx.cmo.fees')

  # other options
  optRBF: true
  allowUnconfirmed: false


  sources: null
  sourcesAmount: null

  coin: Ember.computed.alias('account.unit')

  #state
  addMode: true

  paymentReady: Ember.computed.notEmpty('preparedTx')

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

  autoRemainder: Ember.computed.not('remainderAddr')

  computedRemainder: ( ->
    if !@get('remainderAddr') && @get('sourcesAmount')
      @get('sourcesAmount') - @get('totalAmount')
  ).property('remainderAddr', 'sourcesAmount', 'totalAmount')

  valid: ( ->
    !@get('insuffSources') && !Ember.isEmpty(@get('recipients'))
  ).property('insuffSources', 'recipients.[]')

  totalAmount: ( ->
    recipients = @get('recipients')
    recipients.reduce ((sum, row) ->
        sum += Ember.get(row, 'fullAmount')
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
  signingProgress: Ember.computed.alias('preparedTx.signingProgress')
  signing: Ember.computed.alias('preparedTx.signing')


  accountChanged: ( ->
    @set('ptx', null)
  ).observes('account')

  coinChanged: ( ->
    @set('optRBF', @get('coin.features.rbf'))
  ).observes('coin').on('init')

  setup: (->
    @get('account')
    if Ember.isEmpty(@get('feesEstData'))
      @get('getFeeEstimate').perform()
  ).on('init')

  accountChanged: ( -> @reset()).on('init').observes('account')

  showAdd: Ember.computed.alias('addMode')

  showSummaryPanel: ( ->
    !Ember.isEmpty(@get('recipients')) || (!@get('autoSource') && !Ember.isEmpty(@get('sources')))
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

  getFeeEstimate: task(->
    try
      val = yield @get('cm.api').updateNetworkFeesFromExternalProviders()
      if val
        @set('feesEstData', val)
        value = Ember.get(val, 'fastestFee')
        @set('feesEstValuePerByte', value) if value
        @sendAction('on-change', value)
    catch error
      Ember.Logger.error('Unable to hit fees: ', error)
  )

  backToAutoSource: ( -> @set('sources', Ember.A()) if @get('autoSource')).observes('autoSource')

  reset: ->
    @closeAllAlerts()
    @setProperties
      preparedTx: null
      recipients: Ember.A()
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
        Ember.Logger.error '[SEND] cancelPayment error', err
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
        Ember.Logger.error '[SEND] proposePayment error', err
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
        Ember.Logger.error('error: ', err)
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
      selectAllUnspents: (isEntireBalance && Ember.isEmpty(unspents))
      unspents: unspents
      disableRbf: optRBF,
      allowUnconfirmed: allowUnconfirmed,

    if autoFees
      params.feeMultiplier = feesMult || 1.0
    else
      params.satoshisPerByte = feesPerByte || feesEstValuePerByte

    if !Ember.isEmpty(recipients)
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
        Ember.Logger.error('error: ', err)
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
        @alertSuccess  "<b>#{@get('i18n').t('paysend.success')}:</b> #{@get('i18n').t('paysend.tx-done')}", true
        @reset()
      catch err
        @alertWarning @get('i18n').t('paysend.err.occurred', error: @get('i18n').t_ex(err)), true
    else
      Ember.Logger.error '[SEND] prepared has no fields signatures.', preparedTx, preparedTx.get('hasFieldsSignature')
      Ember.RSVP.reject('invalid prepared tx')
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
        Ember.Logger.error '[SEND] proposePayment error', err
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
        Ember.Logger.error '[SEND] proposePayment error', err
  )

  actions:
    feesChanged: (mult, value) ->
      @setProperties
        feesMult: mult
        feesLabel: Ember.get(value, 'label')

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
      @set('addMode', true) if Ember.isEmpty(r)

    selectSources: (amount, srcs) ->
      @setProperties
        sourcesAmount: amount
        sources: srcs

    toggleAdd: ->
      @set('addMode', true)

)

`export default AdvancedSend`
