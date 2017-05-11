`import Ember from 'ember'`

MainAccountAddressDtRoute = Ember.Route.extend(


  model: (params) ->
    id = Ember.get(params, 'addr_id')

    @get('cm').waitForReady().then( =>
      @get('cm.api').addressGet(@get('cm.currentAccount.cmo'), id, includeTxInfos: true).then((res) =>
          if (addr = Ember.get(res, 'address'))
            @updateList(addr)
            addr
      )
    )


  updateList: (addr) ->
    if (addr && (list = @modelFor('main.account.address')))
      if (c = list.findBy('address', Ember.get(addr, 'address')))
        Ember.setProperties(c, Ember.getProperties(addr, 'meta', 'labels', 'lastRequested'))



  actions:
    addressUpdated: (addr) ->
      @updateList(addr)


)

`export default MainAccountAddressDtRoute`