`import Ember from 'ember'`
`import Configuration from 'melis-cm-svcs/utils/configuration'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

Validations = buildValidations(
  signinPin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

SignInWidget = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')

  signingIn: false
  signInError: null

  signinPin: null

  tryLastAttempt: false

  ready: Ember.computed.alias('cm.ready')

  setup: (->
    @set 'pin', ( Configuration.testPin )

  ).on('willInsertElement')

  deviceLocked: (->
    @get('invalidDevice') || (@get('credentials.attemptsLeft') == 0)
  ).property('credentials.attemptsLeft', 'invalidDevice')

  lowAttempts: (->
    left = @get('credentials.attemptsLeft')
    (left == 1)
  ).property('credentials.attemptsLeft')

  showLowAttempts: (->
    @get('lowAttempts') && !@get('tryLastAttempt')
  ).property('lowAttempts', 'tryLastAttempt')

  signinIcon: (->

    if @get('signingIn') then 'fa fa-spinner fa-spin' else 'fa fa-check'
  ).property('signingIn')


  actions:
    lastTry: ->
      @set('tryLastAttempt', true)


    tryLogin: ->
      cm = @get('cm')
      @set 'signInError', null


      if pin = @get('signinPin')
        @set 'signingIn', true

        cm.deviceGetPassword(pin).then((res) =>

          if Ember.isBlank(res)
            @set 'pin', null
          else if res.password
            cm.walletReOpen(pin)
          else if res.attemptsLeft
            @set 'signInError', "Wrong Pin (#{@get('credentials.attemptsLeft')} attempts left)"

        ).catch((err) =>
          if err.ex == 'CmInvalidDeviceException'
            @set 'signInError', 'Invalid Device'
            @set 'invalidDevice', true

          Ember.Logger.error err
        ).finally( =>
          @set 'signingIn', false
        )

)

`export default SignInWidget`
