import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, set } from '@ember/object'
import { A } from '@ember/array'
import { scheduleOnce } from '@ember/runloop'
import { isEmpty } from '@ember/utils'
import RSVP from 'rsvp'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

SATOSHI = 100000000.0

MainSendController = Controller.extend(Alertable, ModelFactory,

  aa: service('aa-provider')
  ptxsvc: service('cm-ptxs')
  accountInfo: service('cm-account-info')
  scanner: service('scanner-provider')
  curr: service('cm-currency')

  # Query params for redirect payment
  queryParams: ['address', 'pubId', 'amount', 'info', 'open-scan']

  # recipient being added/edited now
  currentRecipient: null

  # all the recipients for the current payment
  recipients: null

  # controller is busy in a network op
  busy: ( ->
    @get('prepareOps.isRunning') ||  @get('confirmOps.isRunning')
  ).property('prepareOps.isRunning', 'confirmOps.isRunning')

  #
  # current tx that has been prepared
  #
  preparedTx: null

  #
  #
  #
  showSummary: false

  #
  #
  #
  signingProgress: alias('preparedTx.signingProgress')
  signing: alias('preparedTx.signing')

  #
  prepareOps: taskGroup().enqueue()
  confirmOps: taskGroup().enqueue()

  #
  # clean everything if current account changes
  #
  accountHasChanged: ( ->
    @setProperties(
      currentRecipient: @createSimpleModel('payment-recipient', account: @get('cm.currentAccount'))
      recipients: A()
      preparedTx: null
    )
    @setRecipientFromQuery()
  ).observes('cm.currentAccount')

  #
  # handles the open-scan query property
  #
  openScannerOnInit: ( ->
    if @get('open-scan')
      scheduleOnce 'afterRender', this, ->
        @openScanner()
  ).observes('open-scan').on('init')


  #
  #
  #
  isEntireBalance: ( ->
    (@get('currentRecipient.entireBalance') || @get('recipients').any((item) -> item.get('entireBalance')))
  ).property('recipients.@each.entireBalance', 'currentRecipient.entireBalance')


  #
  #
  #
  openScanner: ->
    @get('scanner').independentScan().then((data) =>
      if (addr = @get('scanner').getAddressFromData(data, @get('currentAccount.coin')))
        set(@get('currentRecipient'), 'type', 'address')
        set(@get('currentRecipient'), 'value', addr)
        if (amount = get(data, 'queries.amount'))
          scaled = @get('curr').scaleBtc(amount * SATOSHI)
          set(@get('currentRecipient'), 'amount', scaled)
    ).catch((err) ->
      Logger.error "Scanner aborted", err
    )


  #
  #
  #
  setRecipientFromQuery: ( ->
    if (pubid = @get('pubId')) || (addr = @get('address'))
      n =  @createSimpleModel('payment-recipient',
        account: @get('cm.currentAccount')
        pubId: pubid
        value: addr
        amount: @get('amount')
        info: @get('info')
      )
      @set('currentRecipient', n)
  ).observes('pubId', 'address')


  clearState: ->
    @setProperties(
      preparedTx: null
      recipients: []
      currentRecipient: @createSimpleModel('payment-recipient', account: @get('cm.currentAccount'))
    )

  #
  #
  #
  addRecipient: (recipient) ->
    recipients = @get('recipients')

    if recipients.isAny('value', get(recipient, 'value'))
      # would be great to (also) check this on validation
      @alertWarning @get('i18n').t('paysend.err.addr-dup'), true
      false
    else
      recipients.pushObject(recipient)
      @set('currentRecipient',  @createSimpleModel('payment-recipient', account: @get('cm.currentAccount')))
      true


  #
  #
  #
  preparePayment: task((recipients, options) ->
    recipients ?= @get('recipients')
    options ||= {}
    { cm,
      ptxsvc } = @getProperties('cm', 'ptxsvc')

    isEntireBalance = recipients.any((item) -> item.get('entireBalance'))

    if !isEmpty(recipients)
      @closeAllAlerts()

      op = (tfa) ->
        plainRecs = recipients.map((r) -> r.toCmo())

        cm.payPrepare(plainRecs,
          tfa: tfa.payload,
          selectAllUnspents: isEntireBalance,
          disableRbf: !options.optRBF,
          allowUnconfirmed: options.allowUnconfirmed,
          feeMultiplier: options.feesMult || 1.0
        )

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
          @alertWarning "#{@get('i18n').t('paysend.err.occurred', error: err.msg)}", true
  ).group('prepareOps')


  #
  #
  #
  proposePayment: task( ->
    { ptxsvc,
      preparedTx } = @getProperties('ptxsvc', 'preparedTx')

    if preparedTx && !preparedTx.get('hasFieldsSignature')
      try
        res = yield ptxsvc.ptxPropose(preparedTx)
        console.log "propose: ", res
      catch err
        Logger.error('error: ', err)
        @alertWarning "#{@get('i18n').t('paysend.err.occurred', error: err.msg)}", true
  ).group('confirmOps')


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
        @clearState()
      catch err
        @alertWarning @get('i18n').t('paysend.err.occurred', error: @get('i18n').t_ex(err)), true
    else
      Logger.error '[SEND] prepared has no fields signatures.', preparedTx, preparedTx.get('hasFieldsSignature')
      RSVP.reject('invalid prepared tx')
  ).group('confirmOps')

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
  addRecipientPrepare: task( (recipient, opts)->
    if @addRecipient(recipient)
      @set 'showSummary', true
      try
        yield @get('preparePayment').perform(@get('recipients'), opts)
      finally
        @set('showSummary', false)
  )


  #
  #
  #
  cancelPayment: task(->
    if ptx = @get('preparedTx')
      try
        yield @get('cancelTx').perform(ptx)
        @set 'preparedTx', null
      catch err
        Logger.error '[SEND] cancelPayment error', err
  )


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

  accountChanged: (->
    @closeAllAlerts()
    @set('recipients', A())
    @set('currentRecipient', @createSimpleModel('payment-recipient', account: @get('cm.currentAccount')))
  ).observes('cm.currentAccount')

  setup: ( ->
    @set('recipients', A())
    @set('currentRecipient', @createSimpleModel('payment-recipient', account: @get('cm.currentAccount')))

    # cancel
    @get('ptxsvc').on('update-ptx', (ptx) =>
      if (@get('preparedTx.cmo.id') == get(ptx, 'cmo.id')) && !@get('preparedTx.isActive')
        @set('preparedTx', null)
    )
  ).on('init')


  actions:
    openScanner: ->
      @openScanner()

    addRecipientPrepare: (recipient, opts) ->
      @get('addRecipientPrepare').perform(recipient, opts)
      false

    addRecipient: (recipient) ->
      @addRecipient(recipient)
      false

    cancelTx: (tx) ->
      if tx ?= @get('preparedTx')
        @get('cancelTx').perform(tx)

    cancelPayment: ->
      @get('cancelPayment').perform()

    preparePayment: (recipients, opts) ->
      @get('preparePayment').perform(recipients, opts)

    proposePayment: ->
      @get('autoProposePayment').perform()

    confirmPayment: ->
      @get('autoConfirmPayment').perform()



)

export default MainSendController
