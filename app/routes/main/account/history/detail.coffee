import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

HistoryDetailRoute = Route.extend(

  txsvc: service('cm-tx-infos')

  model: (params)->
    @get('cm').waitForReady().then( => if (id = params.txinfo_id) then @get('txsvc').findById(id))
)

export default HistoryDetailRoute