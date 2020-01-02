import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


FeesInput = Component.extend(


  cm: service('cm-session')
  value: null
  coin: null
  account: null

  feesData: null


  getFeeEstimate: task( ->
    return unless (coin = @get('coin.unit'))

    try
      provs = yield @get('cm.api').feeApi.getProviderNames(coin)
      Logger.debug('Fee provs:', coin, provs)
      if provs
        p = provs[Math.floor(Math.random() * provs.length)]
        val = yield @get('cm.api').feeApi.getFeesByProvider(coin, p)()
        Logger.debug('Fee est:', coin, val)
        if val
          @set('feesData', val)
          value = get(val, 'fastestFee')
          @set('value', value) if value
          @sendAction('on-change', value)

    catch error
       Logger.error('Unable to hit fees: ', error)
  )

  coinChanged: ( ->
    @setProperties
      value: null
      feesData: null
  ).observes('coin.unit', 'account')

  setup: (->
    @get('account')
    @get('getFeeEstimate').perform()
  ).on('init')

  actions:
    changedValue: (value) ->
      @set('feesData', null)
      @sendAction('on-change', value)
)

export default FeesInput


