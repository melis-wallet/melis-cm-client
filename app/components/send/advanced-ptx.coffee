`import Ember from 'ember'`

AdvancedPtx = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  account: null
  preparedTx: null


  actions:
    cancelTx: ->
      @sendAction('on-cancel')

    proposeTx: ->
      @sendAction('on-propose')

    confirmTx: ->
      @sendAction('on-confirm')


)


`export default AdvancedPtx`
