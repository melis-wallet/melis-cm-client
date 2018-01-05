`import Ember from 'ember'`

InfoWidget = Ember.Component.extend(

  sent: 132
  balance: 950
  received: 56

  cm: Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')
  account: Ember.computed.alias('cm.currentAccount')


  accountName: (->
    @get('account.cmo.meta.name') || '---'
  ).property('account.cmo')


  amReserved: (->
    @get('coinsvc').formatUnit(@get('account'), @get('account.balance.amReserved'), {blank: '---'})
  ).property('account.cmo')

  amUnconfirmed: (->
    @get('coinsvc').formatUnit(@get('account'), @get('account.balance.amUnconfirmed'), {blank: '---'})
  ).property('account.cmo')

  amAvailable: (->
    @get('coinsvc').formatUnit(@get('account'), @get('account.balance.amAvailable'), {blank: '---'})
  ).property('account.cmo')

  updateValues: ->
    @set('sent', @get('sent') + 1)
    @set('balance', @get('balance') - 1)


  actions:
    createTestUser: ->
      cm = @get('cm')
      cm.fxCreateTestWallet().catch((err) =>
        Ember.Logger.error "Create test user. Error: ", err
      )

)

`export default InfoWidget`
