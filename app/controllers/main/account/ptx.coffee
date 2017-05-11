`import Ember from 'ember'`

MainPtxController = Ember.Controller.extend(

  activePtx: null

  actions:
    setActivePtx: (ptx) ->
      console.log "ptx. ", ptx
      @set 'activePtx', ptx
      @transitionToRoute('main.account.ptx.detail', @get('currentAccount'), ptx)


)

`export default MainPtxController`
