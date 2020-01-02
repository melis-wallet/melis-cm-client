import Service, { inject as service } from '@ember/service'
import Evented from '@ember/object/evented'
import { get, set, computed } from '@ember/object'
import { alias } from '@ember/object/computed'
import RSVP from 'rsvp'

import subscribe from 'ember-cordova-events/utils/subscribe'

import Logger from 'melis-cm-svcs/utils/logger'


CdvDeviceSupport = Service.extend(Evented,
  cm: service('cm-session')
  platform: service('ember-cordova/platform')
  appstate: service('app-state')
  cordova: service('ember-cordova/events')
  keyboard: service('ember-cordova/keyboard')
  splash: service('ember-cordova/splash')
  recovery:  service('cm-recovery-info')

  deviceReady: false
  connectionType: null

  hasMail: false

  paused: false

  isMobile: alias('platform.isHybrid')
  hasDownload: computed.not('isMobile')

  setup: ( ->

    Logger.debug('= CDV Device Support. Mobile support: ', @get('isMobile'))

    @get('splash').hide()

    @set('keyboard.shouldDisableScroll', false)
    @get('keyboard').keyboard().then((kb) -> kb.disableScroll(false))
  ).on('init')

  ready: subscribe('cordova.deviceready', ->
    Logger.debug('CDV Device Ready')
    @set('deviceReady', true)
    @checkMail()
  )

  checkMail: ->
    cordova.plugins.email.isAvailable( (isAvailable) =>
      Logger.debug('CDV Mail is available:', isAvailable)
      @set('hasMail', isAvailable)
    )

  pause: subscribe('cordova.pause', ->
    return unless @get('isMobile')

    Logger.debug('CDV Pause')
    @get('recovery').stopScheduling()
    @set('paused', true)
    @get('cm.api').hintDevicePaused()
  )

  resume: subscribe('cordova.resume', ->
    @get('recovery').startScheduling()

    return unless @get('isMobile')

    Logger.debug('CDV Resume')
    @set('paused', false)
    @get('cm.api').verifyConnectionEstablished()
  )

  offline: subscribe('cordova.offline', ->
    return unless @get('isMobile')

    Logger.debug('CDV Offline')
    @set('connectionType', null)
    @get('cm.api').networkOffline()
  )

  online: subscribe('cordova.online', ->
    return unless @get('isMobile')

    Logger.debug('CDV Online')
    @set('connectionType', navigator.connection.type)
    @get('cm.api').networkOnline()
  )

  backbtn: subscribe('cordova.backbutton', ->
    return unless @get('isMobile')

    Logger.debug('CDV Back')
    @set('appstate.menuExpanded', false)
    @trigger('backbutton')
  )

  menubtn: subscribe('cordova.menubutton', ->
    Logger.debug('CDV Menu')
  )


  mailFile: (subject, name, body, data) ->
    new RSVP.Promise((resolve, reject) =>
      if @get('hasMail')
        cordova.plugins.email.open({
          subject: subject
          body: body
          attachments: "base64:" + name + '//' + window.btoa(data)
        }, (-> resolve()))
      else
        Logger.warn('CDV Mail is not available')
        reject('no-mail')
    )
)

export default CdvDeviceSupport
