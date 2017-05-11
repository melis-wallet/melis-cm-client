`import Ember from 'ember'`
`import { task, timeout } from 'ember-concurrency'`



EX_NAMES =
  fallback: '- Average'
  rock: 'The Rock Trading'
  localbtc: 'Local Bitcoins'

ChangeCurrency = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  cursvc: Ember.inject.service('cm-currency')

  currencies: (->
    @get('cm.currencies').map( (e) ->
      return {id: e, text: e}
    )
  ).property('cm.currencies.[]')


  currency: ( ->
    @get('currencies').findBy('id', @get('cm.globalCurrency'))
  ).property('currencies', 'cm.globalCurrency')


  exchanges: ( ->
    if !Ember.isEmpty((exs = @get('cursvc.knownExchanges')))
      exs.map( (e) ->
        return {id: e, text: (EX_NAMES[e] || (e && e[0].toUpperCase() + e.slice(1)))}
      )
  ).property('cursvc.knownExchanges.[]')

  exchange: ( ->
    @get('exchanges')?.findBy('id', @get('cursvc.currentExchange'))
  ).property('exchanges', 'cursvc.currentExchange')

  actions:
    changeCurrency: (curn)->
      @set('cm.globalCurrency', Ember.get(curn, 'id'))

    changeExchange: (ex) ->
      @set('cursvc.currentExchange', Ember.get(ex, 'id'))
)

`export default ChangeCurrency`
