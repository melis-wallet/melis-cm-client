`import Ember from 'ember'`

LinkToExplorer = Ember.Component.extend(

  tagName: 'span'

  cm: Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')

  hash: null

  url: ( ->
    @get('txsvc').urlToExplorer(@get('hash'))
  ).property('hash', 'txsvc.explorers', 'txsvc.currentExplorer')

)

`export default LinkToExplorer`
