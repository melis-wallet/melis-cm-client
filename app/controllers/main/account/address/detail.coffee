import Controller from '@ember/controller'

MainAddressDtController = Controller.extend(

  txInfos: null

  actions:
    addressUpdated: (addr) ->
      @set('model', addr)
      true

)

export default MainAddressDtController
