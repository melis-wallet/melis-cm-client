`import Ember from 'ember'`

PtxDetailRoute = Ember.Route.extend(

  ptxsvc: Ember.inject.service('cm-ptxs')

  model: (params)->
    @get('cm').waitForReady().then( =>
      id = params.ptx_id
      account = @get('cm.currentAccount')
      if id
        @get('ptxsvc').findById(id, account)

    )
)

`export default PtxDetailRoute`