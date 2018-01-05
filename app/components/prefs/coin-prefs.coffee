import Ember from 'ember'
import { task, taskGroup } from 'ember-concurrency'

EX_NAMES =
  fallback: '- Average'
  rock: 'The Rock Trading'
  localbtc: 'Local Bitcoins'

CoinPrefs = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')
  coin: null

  subunits: Ember.computed.alias('coin.subunits')
  subunit: Ember.computed.alias('coin.subunit')

  explorers: Ember.computed.alias('coin.explorers')
  currentExplorer: Ember.computed.alias('coin.currentExplorer')

  exchanges: ( ->
    if !Ember.isEmpty((exs = @get('coin.knownExchanges')))
      exs.map( (e) ->
        return {id: e, text: (EX_NAMES[e] || (e && e[0].toUpperCase() + e.slice(1)))}
      )
  ).property('coin.knownExchanges.[]')

  exchange: ( ->
    @get('exchanges')?.findBy('id', @get('coin.exchange'))
  ).property('exchanges', 'coin.exchange')


  actions:
    changeUnit: (sub) ->
      @get('coinsvc').storePrefSubunit(@get('coin.unit'), Ember.get(sub, 'id'))

    changeExchange: (ex) ->
      if (id = Ember.get(ex, 'id'))
        @get('coinsvc').storeCoinPref(@get('coin.unit'), 'exchange', id)


    changeExplorer: (ex) ->
      if (id = Ember.get(ex, 'id'))
        @get('coinsvc').storeCoinPref(@get('coin.unit'), 'explorer', id)
)

export default CoinPrefs
