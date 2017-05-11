`import Ember from 'ember'`

MainAccountViewRoute = Ember.Route.extend(
  setupController: (controller) ->
     controller.set('dangerEnabled', false)

)


`export default MainAccountViewRoute`