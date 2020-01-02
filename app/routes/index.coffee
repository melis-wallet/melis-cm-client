import Route from '@ember/routing/route'

IndexRoute = Route.extend(

  beforeModel: (transition) ->
    @transitionTo('wallet.sign-in')
)

export default IndexRoute
