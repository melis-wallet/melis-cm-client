`import Ember from 'ember'`

MainAccountAdvSendRoute = Ember.Route.extend(

  beforeModel: (transition) ->
    if !@get('cm.currentAccount.isComplete')
      @transitionTo('main.account.summary', @get('cm.currentAccount.pubId'))

)

`export default MainAccountAdvSendRoute`