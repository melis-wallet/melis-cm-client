`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

FeesInput = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  value: null

  feesData: null

  getEstimate: task(->
    try
      val = yield @get('cm.api').updateNetworkFeesFromExternalProviders()
      console.error val
      if val
        @set('feesData', val)
        value = Ember.get(val, 'fastestFee')
        @set('value', value) if value
        @sendAction('on-change', value)
    catch error
      Ember.Logger.error('Unable to hit fees: ', error)
  )



  setup: (->
    if Ember.isEmpty(@get('value'))
      @get('getEstimate').perform()
  ).on('init')


  actions:
    changedValue: (value) ->
      @set('feesData', null)
      @sendAction('on-change', value)


)

`export default FeesInput`


