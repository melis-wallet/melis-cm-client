`import Ember from 'ember'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`

MainAddressDtController = Ember.Controller.extend(


  txInfos: null

  actions:
    addressUpdated: (addr) ->
      @set('model', addr)
      true

)

`export default MainAddressDtController`
