`import Ember from 'ember'`

MainAccountAddressRoute = Ember.Route.extend(


  model: ->
    @get('cm').waitForReady().then( =>
      @get('cm.api').addressesGet(@get('cm.currentAccount.cmo'), sortField: 'lastRequested')
    )


  actions:
    selectAddr: (addr) ->
      if a = Ember.get(addr, 'address')
        @transitionTo('main.account.address.detail', @get('cm.currentAccount.num'), a)
)

`export default MainAccountAddressRoute`