import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isBlank } from '@ember/utils'

import { task, taskGroup } from 'ember-concurrency'
import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'

import Logger from 'melis-cm-svcs/utils/logger'


PaymentQuickSend = Component.extend(ModelFactory,

  cm: service('cm-session')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')
  aa: service('aa-provider')
  i18n: service()

  error: null
  success: null

  unit: null

  recipientId: null
  recipientAddr: null
  recipientInfo: null
  amount: null

  info: null

  activeAccount: null

  apiOps: taskGroup().enqueue()


  coin: ( ->
    @get('coinsvc.coins')?.findBy('unit', @get('unit'))
  ).property('coin', 'coinsvc.inited')


  recipient: ( ->
    return if isBlank('activeAccount')

    z = @createSimpleModel('payment-recipient',
      type: if @get('recipientInfo') then 'cm' else 'address'
      value: if @get('recipientInfo') then {pubId: @get('recipientInfo.pubId')} else @get('recipientAddr')
      account: @get('activeAccount')
      amount: @get('coinsvc').formatUnit(@get('activeAccount'), @get('amount'))
      currency: @get('currencySvc.currency')
      info: @get('info')
    )
    console.debug(z)
    return z
  ).property('coin', 'recipientInfo', 'recipientAddr', 'activeAccount', 'amount', 'info')


  changedAccts: ( ->
    if isBlank(@get('activeAccount')) && (unit = @get('unit'))
      @set('activeAccount', @get('cm.accounts')?.findBy('coin', unit))
  ).observes('accounts', 'unit').on('init')


  enoughBalance: ( ->
    @get('activeAccount.balance.amAvailable') > @get('recipient.fullAmount')
  ).property('activeAccount.balance.amAvailable', 'recipient.fullAmount')


  setup: ( ->
    Logger.error("[QuickSend] Unit is required") if isBlank('unit')

    if @get('recipientId') && isBlank(@get('recipientInfo'))
      @get('findRecipient').perform()
  ).on('init')

  pubIdChanged: ( ->
    if @get('recipientId')
      @get('findRecipient').perform()
  ).observes('pubId')


  findRecipient: task( ->
    api = @get('cm.api')
    @set('recipientInfo', null)
    if (pubId = @get('recipientId'))
      res = yield api.accountGetPublicInfo(name: pubId)
      @set('recipientInfo', res)
  ).group('apiOps')


  payNow: task( ->
    api = @get('cm.api')
    @setProperties
      error: null
      success: null

    if (acct = @get('activeAccount.cmo')) && (recipient = @get('recipient'))

      try
        op = (tfa) ->
          api.payRecipients(acct, [recipient.toCmo()], tfa: tfa.payload)

        yield @get('aa').tfaAuth(op, @get('i18n').t('paysend.prompts.prepare'))
        @set 'success', @get('i18n').t('quicksend.success')
      catch error
        Logger.error error
        @set 'error', @get('i18n').t('quicksend.error.pay')

  ).group('apiOps')

  actions:
    payNow: ->
      @get('payNow').perform()
)

export default PaymentQuickSend
