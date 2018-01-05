`import Ember from 'ember'`

TxDetail = Ember.Component.extend(

  cm:  Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')
  ptxSvc: Ember.inject.service('cm-ptxs')

  editLabels: false

  tx: null
  ptx: null

  negative: Ember.computed.lt('tx.amount', 0)

  fetchPtx: ->
    console.log "TX: ", @get('tx')
    if Ember.isBlank(@get('ptx')) && (hash = @get('tx.cmo.tx'))
      @get('ptxSvc').getPtxByHash(hash).then((res) =>
        console.error res
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


`export default TxDetail`
