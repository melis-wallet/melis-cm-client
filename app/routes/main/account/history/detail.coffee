`import Ember from 'ember'`

HistoryDetailRoute = Ember.Route.extend(

  txsvc: Ember.inject.service('cm-tx-infos')

  model: (params)->
    @get('cm').waitForReady().then( =>
      if (id = params.txinfo_id)
        @get('txsvc').findById(id)
    )
)

`export default HistoryDetailRoute`