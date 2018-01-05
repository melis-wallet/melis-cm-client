`import Ember from 'ember'`

MainAccountSendRoute = Ember.Route.extend(

  beforeModel: (transition) ->
    if !@get('cm.currentAccount.isComplete')
      @transitionTo('main.account.summary', @get('cm.currentAccount.pubId'))

)

`export default MainAccountSendRoute`