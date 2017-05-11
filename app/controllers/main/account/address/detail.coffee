`import Ember from 'ember'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`

MainAddressDtController = Ember.Controller.extend(


  addressesSorting: ['lastRequested:desc']
  addresses: Ember.computed.sort('model', 'addressesSorting')


  actions:
    addressUpdated: (addr) ->
      @set('model', addr)
      true

)

`export default MainAddressDtController`
