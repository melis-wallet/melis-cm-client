import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

import Logger from 'melis-cm-svcs/utils/logger'

WalletSignInRoute = Route.extend(

  credentials: service('cm-credentials')

  beforeModel: (transition) ->
    superResult = @_super(transition)

    if !@get('cm.ready')
      if !@get('credentials.validCredentials')
        @transitionTo('wallet.welcome')
    else
      @goToDashboard()
    return(superResult)


  goToDashboard: ->
    acc = @get('cm.visibleAccts.firstObject.pubId')
    if @get('cm.simpleMode')
      @transitionTo('main.account.summary', acc)
    else
      @transitionTo('main.account.dashboard', acc)

  actions:
    successSignIn: ->
      Logger.debug '= success sign-in'
      if (transition = @get('cm.attemptedTransition'))
        transition.retry();
        @set('cm.attemptedTransition', null)
      else
        @goToDashboard()



)

`export default WalletSignInRoute`
