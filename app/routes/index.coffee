`import Ember from 'ember'`


IndexRoute = Ember.Route.extend(

  beforeModel: (transition) ->
    @transitionTo('wallet.sign-in')

)

`export default IndexRoute`
