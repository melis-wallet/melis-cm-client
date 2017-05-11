`import Ember from 'ember'`
`import config from '../config/environment';`

AuthenticatedRoute = Ember.Mixin.create(

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')


  _authenticationNeeded: (transition) ->
    transition.abort()
    @get('cm').set('attemptedTransition', transition)
    @transitionTo('wallet.sign-in')


  beforeModel: (transition) ->
    superResult = @_super(transition)

    if !@get('cm.ready')
      if @get('credentials.validCredentials')

        # for debug
        pin = config['melis-session'].autologinTestPin

        if pin && config['melis-session'].testMode
          Ember.Logger.warn " -- Autologging with pin #{pin} -- "
          @get('cm').scheduleWalletOpen(pin: pin).catch( =>
            @_authenticationNeeded(transition)
          )
        else
          @_authenticationNeeded(transition)
      else
        @transitionTo('wallet.enroll')

    return(superResult)


  actions:
    need_signin: ->
      @transitionTo('wallet.sign-in')
)

`export default AuthenticatedRoute`
