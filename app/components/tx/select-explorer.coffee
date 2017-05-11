`import Ember from 'ember'`

SelectExplorer = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')

  explorers: Ember.computed.alias('txsvc.explorers')
  currentExplorer: Ember.computed.alias('txsvc.currentExplorer')

  actions:
    changeExplorer: (ex) ->
      if (id = Ember.get(ex, 'id'))
        @set('txsvc.blockExplorer', id)

)

`export default SelectExplorer`
