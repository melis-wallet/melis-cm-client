import Route from '@ember/routing/route'

MainAccountSendRoute = Route.extend(

  beforeModel: (transition) ->
    if !@get('cm.currentAccount.isComplete')
      @transitionTo('main.account.summary', @get('cm.currentAccount.pubId'))
)

export default MainAccountSendRoute