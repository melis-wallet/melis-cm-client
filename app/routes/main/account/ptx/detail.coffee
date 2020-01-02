import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

PtxDetailRoute = Route.extend(

  ptxsvc: service('cm-ptxs')

  model: (params)->
    @get('cm').waitForReady().then( =>
      id = params.ptx_id
      account = @get('cm.currentAccount')
      if id
        @get('ptxsvc').findById(id, account)

    )
)

export default PtxDetailRoute