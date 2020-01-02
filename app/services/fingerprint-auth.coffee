import Service, { inject as service } from '@ember/service'
import Evented from '@ember/object/evented'
import { alias } from '@ember/object/computed'
import { isBlank } from '@ember/utils'
import { get, set } from '@ember/object'
import RSVP from 'rsvp'

import subscribe from 'ember-cordova-events/utils/subscribe'
import { storageFor } from 'ember-local-storage'

import Logger from 'melis-cm-svcs/utils/logger'

CLIENTID = 'melis-cm-wallet'

FingerPrint = Service.extend(Evented,

  cordova: service('ember-cordova/events')
  platform: service('ember-cordova/platform')
  cm: service('cm-session')

  isAvailable: false
  isHardwareDetected: false
  hasEnrolledFingerprints: false

  isSupported: alias('isAvailable')

  walletstate: storageFor('wallet-state')
  credentials: alias('walletstate.touchCreds')

  successfullyEnrolled: ( ->
    @get('isAvailable') && !isBlank(@get('credentials'))
  ).property('isAvailable', 'credentials')

  serviceReady: false
  userId: 'melis-user'

  setup: ( ->
    Logger.debug '[fpa] service started'
  ).on('init')

  ready: subscribe('cordova.deviceready', ->
    return unless @get('platform.isAndroid')

    FingerprintAuth.isAvailable(( (result) =>
      if result.isAvailable
        Logger.debug('[fpa] fingerprint is available')
        @setProperties(result)
        if !@get('serviceReady')
          @set('serviceReady', true)
          @trigger('service-ready')
      else
        Logger.debug('[fpa] fingerprint is not available')
    ), ((error) ->
        Logger.error('[fpa] fingerprint check error', error)
    ))
  )


  disable: ->
    return if !@get('successfullyEnrolled') || isBlank(token = @get('credentials'))

    new RSVP.Promise((resolve, reject) =>
      Logger.debug "[fpa] deleting"
      resolve() unless @get('isSupported')

      info =
        clientId: CLIENTID
        username: @get('userId')
        token: token

      success = (result) =>
        Logger.debug('[fpa] fingerprint delete SUCCESS', result)

        resolve(result)
      error = (error) =>
        Logger.error('[fpa] fingerprint delete error', error)
        reject(error)

      @set('credentials', null)
      FingerprintAuth.delete(info, success, error)
    )


  enroll: (pin) ->

    new RSVP.Promise((resolve, reject) =>
      Logger.debug "[fps] enrolling"
      resolve() unless @get('isSupported')

      enroll =
        disableBackup: true
        clientId: CLIENTID
        username: @get('userId')
        password: pin

      success = (result) =>
        Logger.debug('[fpa] fingerprint enroll SUCCESS', result)
        if result && (token = get(result, 'token'))
          @set('credentials', token)
          resolve(result)
        else
          reject('no token')

      error = (error) =>
        Logger.error('[fpa] fingerprint enroll error', error)
        reject(error)
      FingerprintAuth.encrypt(enroll, success, error)
    )


  login: ->
    return if !@get('successfullyEnrolled') || isBlank(token = @get('credentials'))

    new RSVP.Promise((resolve, reject) =>
      login =
        disableBackup: true
        language: @get('cm.locale')
        clientId: CLIENTID
        username: @get('userId')
        token: token

      success = (result) =>
        Logger.debug('[fpa] fingerprint login SUCCESS', result)
        if result && (password = get(result, 'password'))
          result.pin ||= result.password
          resolve(result)
        else
          reject('no password')

      error = (error) =>
        Logger.error('[fpa] fingerprint login error', error)
        reject(error)

      FingerprintAuth.decrypt(login, success, error)
    )
)


export default FingerPrint
