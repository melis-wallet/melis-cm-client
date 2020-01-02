import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get, set, computed } from '@ember/object'
import { isBlank } from '@ember/utils'

TxDetail = Component.extend(

  cm:  service('cm-session')
  txsvc: service('cm-tx-infos')
  ptxSvc: service('cm-ptxs')

  editLabels: false

  tx: null
  ptx: null

  negative: computed.lt('tx.amount', 0)

  fetchPtx: ->
    console.log "TX: ", @get('tx')
    if isBlank(@get('ptx')) && (hash = @get('tx.cmo.tx'))
      @get('ptxSvc').getPtxByHash(hash).then((res) =>
        @set 'ptx', res
      )


  txChanged: ( ->
    if @get('tx.negative') && @get('tx.account.isMultisig')
      @fetchPtx()
  ).observes('tx').on('didInsertElement')

  actions:

    showPtx: ->
      @set 'showPtx', true
      @fetchPtx()

    hidePtx: ->
      @set 'showPtx', false

    changeTxInfo: (value)->
      @sendAction('on-change-tx-info', value, @get('tx'))


    changeTxLabels: (labels)->
      @sendAction('on-change-tx-labels', labels, @get('tx'))

)

export default TxDetail
