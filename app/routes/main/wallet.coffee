import Route from '@ember/routing/route'


MainWalletRoute = Route.extend(
  setupController: (controller) ->
     controller.set('dangerEnabled', false)

)

export default MainWalletRoute