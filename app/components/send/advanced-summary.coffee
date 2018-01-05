`import Ember from 'ember'`


AdvancedSummary = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')


  account: null
  parent: null


  valid: Ember.computed.alias('parent.valid')

  actions:
    preparePayment: ->
      @sendAction('on-prepare')

    resetPayment: ->
      @sendAction('on-reset')

)

`export default AdvancedSummary`


