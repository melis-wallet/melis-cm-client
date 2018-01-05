`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C



MainAccountAddressRoute = Ember.Route.extend(


  model: ->
    @get('cm').waitForReady().then( =>
      @get('cm.api').addressesGet(@get('cm.currentAccount.cmo'), sortField: 'lastRequested', sortDir: C.DIR_DESCENDING)
    )


  actions:
    selectAddr: (addr) ->
      if a = Ember.get(addr, 'address')
        @transitionTo('main.account.address.detail', @get('cm.currentAccount.pubId'), a)
      true
)

`export default MainAccountAddressRoute`