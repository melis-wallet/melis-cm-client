`import Ember from 'ember'`
`import subscribe from 'ember-cordova-events/utils/subscribe'`
`import { storageFor } from 'ember-local-storage'`

CLIENTID = 'melis-cm-wallet'

FingerPrint = Ember.Service.extend(Ember.Evented,

  cordova: Ember.inject.service('ember-cordova/events')
  platform: Ember.inject.service('ember-cordova/platform')
  cm: Ember.inject.service('cm-session')

  isAvailable: false
  isHardwareDetected: false
  hasEnrolledFingerprints: false

  isSupported: Ember.computed.alias('isAvailable')

  walletstate: storageFor('wallet-state')
  credentials: Ember.computed.alias('walletstate.touchCreds')

  successfullyEnrolled: ( ->
    @get('isAvailable') && !Ember.isBlank(@get('credentials'))
  ).property('isAvailable', 'credentials')

  serviceReady: false
  userId: 'melis-user'

  setup: ( ->
    Ember.Logger.debug '[fpa] service started'
  ).on('init')

  ready: subscribe('cordova.deviceready', ->
    return unless @get('platform.isAndroid')

    FingerprintAuth.isAvailable(( (result) =>
      if result.isAvailable
        Ember.Logger.debug('[fpa] fingerprint is available')
        @setProperties(result)
        if !@get('serviceReady')
          @set('serviceReady', true)
          @trigger('service-ready')
      else
        Ember.Logger.debug('[fpa] fingerprint is not available')
    ), ((error) ->
        Ember.Logger.error('[fpa] fingerprint check error', error)
    ))
  )


  disable: ->
    return if !@get('successfullyEnrolled') || Ember.isBlank(token = @get('credentials'))

    new Ember.RSVP.Promise((resolve, reject) =>
      Ember.Logger.debug "[fpa] deleting"
      resolve() unless @get('isSupported')

      info =
        clientId: CLIENTID
        username: @get('userId')
        token: token

      success = (result) =>
        Ember.Logger.debug('[fpa] fingerprint delete SUCCESS', result)

        resolve(result)
      error = (error) =>
        Ember.Logger.error('[fpa] fingerprint delete error', error)
        reject(error)

      @set('credentials', null)
      FingerprintAuth.delete(info, success, error)
    )


  enroll: (pin) ->

    new Ember.RSVP.Promise((resolve, reject) =>
      Ember.Logger.debug "[fps] enrolling"
      resolve() unless @get('isSupported')

      enroll =
        disableBackup: true
        clientId: CLIENTID
        username: @get('userId')
        password: pin

      success = (result) =>
        Ember.Logger.debug('[fpa] fingerprint enroll SUCCESS', result)
        if result && (token = Ember.get(result, 'token'))
          @set('credentials', token)
          resolve(result)
        else
          reject('no token')

      error = (error) =>
        Ember.Logger.error('[fpa] fingerprint enroll error', error)
        reject(error)
      FingerprintAuth.encrypt(enroll, success, error)
    )


  login: ->
    return if !@get('successfullyEnrolled') || Ember.isBlank(token = @get('credentials'))

    new Ember.RSVP.Promise((resolve, reject) =>
      login =
        disableBackup: true
        language: @get('cm.locale')
        clientId: CLIENTID
        username: @get('userId')
        token: token

      success = (result) =>
        Ember.Logger.debug('[fpa] fingerprint login SUCCESS', result)
        if result && (password = Ember.get(result, 'password'))
          result.pin ||= result.password
          resolve(result)
        else
          reject('no password')

      error = (error) =>
        Ember.Logger.error('[fpa] fingerprint login error', error)
        reject(error)

      FingerprintAuth.decrypt(login, success, error)
    )
)


`export default FingerPrint`
