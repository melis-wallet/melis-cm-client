`import Ember from 'ember'`

WalletSignInRoute = Ember.Route.extend(

  credentials: Ember.inject.service('cm-credentials')

  beforeModel: (transition) ->
    superResult = @_super(transition)

    if !@get('cm.ready')
      if !@get('credentials.validCredentials')
        @transitionTo('wallet.welcome')
    else
      @goToDashboard()
    return(superResult)


  goToDashboard: ->
    acc = (@get('cm.visibleAccts.firstObject.num') || 0)
    if @get('cm.simpleMode')
      @transitionTo('main.account.summary', acc)
    else
      @transitionTo('main.account.dashboard', acc)

  actions:
    successSignIn: ->
      Ember.Logger.debug '= success sign-in'
      if (transition = @get('cm.attemptedTransition'))
        transition.retry();
        @set('cm.attemptedTransition', null)
      else
        @goToDashboard()



)

`export default WalletSignInRoute`
