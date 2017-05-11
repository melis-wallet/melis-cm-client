`import Ember from 'ember'`

TxsList = Ember.Component.extend(

  cm:  Ember.inject.service('cm-session')

  page: 0
  ptxs: null

  refreshPtxs: (account, fromdate, paging) ->
    @get('cm.api').txInfosGet(account).then((ptxs) =>
      @set('ptxs', ptxs.list)
    ).catch((err) ->
      console.error "Error while fetching txs:", err
    )


  setup: (->
    @set('ptxs', Ember.A())
    if account = @get('cm.currentAccount.cmo')
      api = @get('cm.api')
      @refreshPtxs(account)
  ).observes('cm.currentAccount').on('init')

)


`export default TxsList`
