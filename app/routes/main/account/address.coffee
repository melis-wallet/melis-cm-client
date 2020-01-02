import Route from '@ember/routing/route'
import { get } from '@ember/object'
import CMCore from 'npm:melis-api-js'


C = CMCore.C

MainAccountAddressRoute = Route.extend(


  model: ->
    @get('cm').waitForReady().then( =>
      @get('cm.api').addressesGet(@get('cm.currentAccount.cmo'), sortField: 'lastRequested', sortDir: C.DIR_DESCENDING)
    )


  actions:
    selectAddr: (addr) ->
      if a = get(addr, 'address')
        @transitionTo('main.account.address.detail', @get('cm.currentAccount.pubId'), a)
      true
)

export default MainAccountAddressRoute