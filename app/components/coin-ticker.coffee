import Ember from 'ember'

CoinTicker = Ember.Component.extend(

  currencySvc: Ember.inject.service('cm-currency')
  coinsvc: Ember.inject.service('cm-coin')

  coin: 'BTC'

  unit: ( ->
    if coin = @get('coin')
      @get('coinsvc.coins').findBy('tsym', coin)
  ).property('coin')

  history: Ember.computed.alias('unit.history')
  value: Ember.computed.alias('unit.value')

  compact: false

  actions:
    toggleGraph: ->
      if (types = @get('unit.histTypes')) && (active = @get('unit.activeHist'))
        i = types.indexOf(active)
        next = types[ if ( i == types.length - 1) then 0 else ( i + 1 )]
        @set('unit.activeHist', next)

)

export default CoinTicker
