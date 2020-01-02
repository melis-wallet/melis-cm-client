import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { schedule } from '@ember/runloop'

import Configuration from 'melis-cm-svcs/utils/configuration'
import { task, timeout, taskGroup } from 'ember-concurrency'
import { validator, buildValidations } from 'ember-cp-validations'
import Fpa from 'melis-cm-client/mixins/fingerprint-auth'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  signinPin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]

)

SignInWidget = Component.extend(Validations, Fpa,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  i18n: service()

  signinPin: null
  signInError: null

  tryLastAttempt: false

  apiOps: taskGroup().drop()

  setup: (->
    schedule 'afterRender', this, (-> @.$('input#signin_pin').focus())
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


  clearErrors: (-> @set('signInError', null)).observes('signinPin')

  formValidity: (->
    if @get('signInError')
      'has-feedback has-error'
    else if @get('validations.isValid')
      'has-feedback has-success'
  ).property('signInError', 'validations.isValid')

  buttonDisabled: (->
    @get('apiOps.isRunning') || @get('signInError')
  ).property('apiOps.isRunning', 'signInError')

  onValidFpa: (pin) ->
    @set('signinPin', pin)
    @get('tryLogin').perform(pin)


  tryLogin: task((pin) ->
    cm = @get('cm')
    @setProperties
      signInError: null
      genericError: null

    try
      res = yield cm.walletReOpen(pin)
      @sendAction('on-success', res)
    catch err
      Logger.error 'Sign-in error: ', err
      switch err.ex
        when 'CmInvalidClientException'
          @set 'barredClient', true
        when 'WrongPin'
          @set 'signInError', @get('i18n').t('wallet.signin.error.wrong', attempts: err.attemptsLeft)
        when 'CmInvalidDeviceException'
          @setProperties
            invalidDevice: true
            signInError: @get('i18n').t('wallet.signin.error.invalid')
        else
          @setProperties
            signInError:  @get('i18n').t('wallet.signin.error.short')
            genericError: true
  ).group('apiOps')

  actions:
    lastTry: ->
      @set('tryLastAttempt', true)

    tryLogin: ->
      if (pin = @get('signinPin')) && @get('validations.isValid')
        @get('tryLogin').perform(pin)

)


export default SignInWidget
