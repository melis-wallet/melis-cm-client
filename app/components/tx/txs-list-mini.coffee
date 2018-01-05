`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

TxsList = Ember.Component.extend(

  cm:  Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')


  classNames: ['zhistory-container']


  txs: null
  selected: null

  account: null

  txsSorting: ['cd:desc']
  txsSorted: Ember.computed.sort('txs', 'txsSorting')


  actions:
    selectTx: (tx) ->
      console.log("Select: ", tx)

)

`export default TxsList`

