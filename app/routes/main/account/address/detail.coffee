import Route from '@ember/routing/route'
import { get, setProperties, getProperties } from '@ember/object'

import Logger from 'melis-cm-svcs/utils/logger'

MainAccountAddressDtRoute = Route.extend(

  txInfos: null

  model: (params) ->
    id = get(params, 'addr_id')

    @get('cm').waitForReady().then( =>
      @get('cm.api').addressGet(@get('cm.currentAccount.cmo'), id, includeTxInfos: true).then((res) =>
          @set('txInfos', get(res, 'txInfos.list'))
          if (addr = get(res, 'address'))

            @updateList(addr)
            addr
      ).catch((e) -> Logger.error('Error fetching addr:', e))
    )

  setupController: (controller, model) ->
    @_super(controller, model)
    controller.set('txInfos', @get('txInfos'))


  updateList: (addr) ->
    model = @modelFor('main.account.address')
    if (addr && model && (list = get(model, 'list')))
      if (c = list.findBy('address', get(addr, 'address')))
        setProperties(c, getProperties(addr, 'meta', 'labels', 'lastRequested'))

  actions:
    addressUpdated: (addr) ->
      @updateList(addr)


)

`export default MainAccountAddressDtRoute`