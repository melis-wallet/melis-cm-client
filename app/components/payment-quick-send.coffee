`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

PaymentQuickSend = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')
  aa: Ember.inject.service('aa-provider')
  i18n: Ember.inject.service()

  error: null
  success: null

  recipient: null

  apiOps: taskGroup().drop()

  currency: Ember.computed.alias('currencySvc.currencySymbol')
  currencyAmount: ( ->
    amount = @get('recipient.amount')
    @get('currencySvc').convertTo(amount)
  ).property('recipient.amount', 'currencySvc.value')

  accounts: Ember.computed.alias('cm.accounts')
  selectedAccount: null

  selectableAccts: ( ->
    @get('accounts').map((a) =>
      {id: a.get('num'), value: a.get('name')}
    )
  ).property('accounts', 'recipient')

  activeAccount: ( ->
    console.log "changed! ", @get('selectedAccount')
    @get('accounts').findBy('num', @get('selectedAccount'))
  ).property('selectedAccount')

  changedAccts: ( ->
    if Ember.isBlank(@get('selectedAccount'))
      @set('selectedAccount', @get('accounts.firstObject.num'))

  ).observes('accounts').on('init')


  enoughBalance: ( ->
    @get('activeAccount.amSummary') > @get('recipient.amount')
  ).property('activeAccount', 'recipient.amount')


  payNow: task( ->
    api = @get('cm.api')
    @setProperties
      error: null
      success: null

    if (acct = @get('activeAccount.cmo')) && (recipient = @get('recipient')) && (pubId = @get('recipient.pubId'))

      try
        res = yield api.getPaymentAddressForAccount(pubId, Ember.get(recipient, 'info'))
      catch error
        Ember.Logger.error error
        @set('error', @get('i18n').t('quicksend.error.addr'))

      if res
        console.log "addr ok ", res
        rcpt = {
          address: res
          amount: recipient.get('amount')
          info: recipient.get('info')
        }
      else
        return


      try
        console.error "HEEEEE"
        op = (tfa) =>
          api.payRecipients(acct, [rcpt], tfa: tfa.payload)


        yield @get('aa').tfaAuth(op, @get('i18n').t('paysend.prompts.prepare'))
        @set 'success', @get('i18n').t('quicksend.success')
      catch error
        Ember.Logger.error error
        @set 'error', @get('i18n').t('quicksend.error.pay')



  ).group('apiOps')

  actions:
    payNow: ->
      @get('payNow').perform()


)

`export default PaymentQuickSend`
