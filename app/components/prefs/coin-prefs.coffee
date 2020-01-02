import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import { get } from '@ember/object'

EX_NAMES =
  fallback: '- Average'
  rock: 'The Rock Trading'
  localbtc: 'Local Bitcoins'

CoinPrefs = Component.extend(


  cm: service('cm-session')
  coinsvc: service('cm-coin')
  coin: null

  subunits: alias('coin.subunits')
  subunit: alias('coin.subunit')

  explorers: alias('coin.explorers')
  currentExplorer: alias('coin.currentExplorer')

  exchanges: ( ->
    if !isEmpty((exs = @get('coin.knownExchanges')))
      exs.map( (e) ->
        return {id: e, text: (EX_NAMES[e] || (e && e[0].toUpperCase() + e.slice(1)))}
      )
  ).property('coin.knownExchanges.[]')

  exchange: ( ->
    @get('exchanges')?.findBy('id', @get('coin.exchange'))
  ).property('exchanges', 'coin.exchange')


  actions:
    changeUnit: (sub) ->
      @get('coinsvc').storePrefSubunit(@get('coin.unit'), get(sub, 'id'))

    changeExchange: (ex) ->
      if (id = get(ex, 'id'))
        @get('coinsvc').storeCoinPref(@get('coin.unit'), 'exchange', id)


    changeExplorer: (ex) ->
      if (id = get(ex, 'id'))
        @get('coinsvc').storeCoinPref(@get('coin.unit'), 'explorer', id)
)

export default CoinPrefs
