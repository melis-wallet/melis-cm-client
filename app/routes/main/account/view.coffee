import Route from '@ember/routing/route'

MainAccountViewRoute = Route.extend(
  setupController: (controller) ->
     controller.set('dangerEnabled', false)

)


export default MainAccountViewRoute