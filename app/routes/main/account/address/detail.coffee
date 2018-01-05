`import Ember from 'ember'`

MainAccountAddressDtRoute = Ember.Route.extend(

  txInfos: null

  model: (params) ->
    id = Ember.get(params, 'addr_id')

    @get('cm').waitForReady().then( =>
      @get('cm.api').addressGet(@get('cm.currentAccount.cmo'), id, includeTxInfos: true).then((res) =>
          @set('txInfos', Ember.get(res, 'txInfos.list'))
          if (addr = Ember.get(res, 'address'))

            @updateList(addr)
            addr
      ).catch((e) ->Ember.Logger.error('Error fetching addr:', e))
    )

  setupController: (controller, model) ->
    @_super(controller, model)
    controller.set('txInfos', @get('txInfos'))


  updateList: (addr) ->
    model = @modelFor('main.account.address')
    if (addr && model && (list = Ember.get(model, 'list')))
      if (c = list.findBy('address', Ember.get(addr, 'address')))
        Ember.setProperties(c, Ember.getProperties(addr, 'meta', 'labels', 'lastRequested'))

  actions:
    addressUpdated: (addr) ->
      @updateList(addr)


)

`export default MainAccountAddressDtRoute`