import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import Logger from 'melis-cm-svcs/utils/logger'

InfoWidget = Component.extend(

  sent: 132
  balance: 950
  received: 56

  cm: service('cm-session')
  coinsvc: service('cm-coin')
  account: alias('cm.currentAccount')


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
        Logger.error "Create test user. Error: ", err
      )

)

export default InfoWidget
