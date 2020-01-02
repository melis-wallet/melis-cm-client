import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

CoinTicker = Component.extend(

  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')

  coin: 'BTC'

  unit: ( ->
    if coin = @get('coin')
      @get('coinsvc.coins').findBy('tsym', coin)
  ).property('coin')

  history: alias('unit.history')
  value: alias('unit.value')
  time: alias('unit.currencyValue.time')

  compact: false

  actions:
    toggleGraph: ->
      if (types = @get('unit.histTypes')) && (active = @get('unit.activeHist'))
        i = types.indexOf(active)
        next = types[ if ( i == types.length - 1) then 0 else ( i + 1 )]
        @set('unit.activeHist', next)

)

export default CoinTicker
