import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { A } from '@ember/array'

import Logger from 'melis-cm-svcs/utils/logger'


TxsList = Component.extend(

  cm:  service('cm-session')

  page: 0
  ptxs: null

  refreshPtxs: (account, fromdate, paging) ->
    @get('cm.api').txInfosGet(account).then((ptxs) =>
      @set('ptxs', ptxs.list)
    ).catch((err) ->
      Logger.error "Error while fetching txs:", err
    )


  setup: (->
    @set('ptxs', A())
    if account = @get('cm.currentAccount.cmo')
      api = @get('cm.api')
      @refreshPtxs(account)
  ).observes('cm.currentAccount').on('init')
)


export default TxsList
