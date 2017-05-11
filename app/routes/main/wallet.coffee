`import Ember from 'ember'`

MainWalletRoute = Ember.Route.extend(
  setupController: (controller) ->
     controller.set('dangerEnabled', false)

)

`export default MainWalletRoute`