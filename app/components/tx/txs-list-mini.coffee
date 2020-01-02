import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { sort } from '@ember/object/computed'


TxsList = Component.extend(

  cm:  service('cm-session')
  txsvc: service('cm-tx-infos')


  classNames: ['zhistory-container']


  txs: null
  selected: null

  account: null

  txsSorting: ['cd:desc']
  txsSorted: sort('txs', 'txsSorting')


  actions:
    selectTx: (tx) ->
      console.log("Select: ", tx)

)

export default TxsList

