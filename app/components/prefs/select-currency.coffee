import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import { task, timeout } from 'ember-concurrency'


ChangeCurrency = Component.extend(

  cm: service('cm-session')
  cursvc: service('cm-currency')

  value: null

  currencies: (->
    @get('cm.currencies').map( (e) ->
      return {id: e, text: e}
    )
  ).property('cm.currencies.[]')


  currency: ( ->
    @get('currencies').findBy('id', @get('value'))
  ).property('currencies', 'value')



  actions:
    changeCurrency: (curn)->
      if curn && (id =  get(curn, 'id'))
        @sendAction('on-change', id)

      #@set('cm.globalCurrency', get(curn, 'id'))

)

export default ChangeCurrency
