`import Ember from 'ember'`

MainAccounReceiveRoute = Ember.Route.extend(

  service: Ember.inject.service('cm-address-provider')

  beforeModel: (transition) ->
    if !@get('cm.currentAccount.isComplete')
      @transitionTo('main.account.summary', @get('cm.currentAccount.num'))

)

`export default MainAccounReceiveRoute`