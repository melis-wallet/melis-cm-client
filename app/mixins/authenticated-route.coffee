import Mixin from '@ember/object/mixin'
import { inject as service } from '@ember/service'

import Logger from 'melis-cm-svcs/utils/logger'

import config from '../config/environment'


AuthenticatedRoute = Mixin.create(

  cm: service('cm-session')
  credentials: service('cm-credentials')


  _authenticationNeeded: (transition) ->
    transition.abort()
    @get('cm').set('attemptedTransition', transition)
    @transitionTo('wallet.sign-in')


  beforeModel: (transition) ->
    superResult = @_super(transition)

    if !@get('cm.ready')
      if @get('credentials.validCredentials')

        # for debug
        pin = config['melis-session']?.autologinTestPin

        if pin && config['melis-session'].testMode
          Logger.warn " -- Autologging with pin #{pin} -- "
          @get('cm').scheduleWalletOpen(pin: pin).catch( =>
            @_authenticationNeeded(transition)
          )
        else
          @_authenticationNeeded(transition)
      else
        @transitionTo('wallet.welcome')

    return(superResult)


  actions:
    need_signin: ->
      @transitionTo('wallet.sign-in')
)

export default AuthenticatedRoute
