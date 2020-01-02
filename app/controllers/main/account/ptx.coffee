import Controller from '@ember/controller'

MainPtxController = Controller.extend(

  activePtx: null

  actions:
    setActivePtx: (ptx) ->
      @set 'activePtx', ptx
      @transitionToRoute('main.account.ptx.detail', @get('currentAccount'), ptx)


)

export default MainPtxController
