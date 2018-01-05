`import Ember from 'ember'`
`import { task, timeout } from 'ember-concurrency'`


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



  actions:
    changeCurrency: (curn)->
      @set('cm.globalCurrency', Ember.get(curn, 'id'))

)

`export default ChangeCurrency`
