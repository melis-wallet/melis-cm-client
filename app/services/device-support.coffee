`import Ember from 'ember'`
`import subscribe from 'ember-cordova-events/utils/subscribe'`

CdvDeviceSupport = Ember.Service.extend(Ember.Evented,
  cm: Ember.inject.service('cm-session')
  platform: Ember.inject.service('ember-cordova/platform')
  appstate: Ember.inject.service('app-state')
  cordova: Ember.inject.service('ember-cordova/events')
  keyboard: Ember.inject.service('ember-cordova/keyboard')
  splash: Ember.inject.service('ember-cordova/splash')

  recovery:  Ember.inject.service('cm-recovery-info')

  deviceReady: false
  connectionType: null

  paused: false

  isMobile: Ember.computed.alias('platform.isHybrid')

  setup: ( ->

    Ember.Logger.debug('= CDV Device Support. Mobile support: ', @get('isMobile'))

    @get('splash').hide()

    @set('keyboard.shouldDisableScroll', false)
    @get('keyboard').keyboard().then((kb) -> kb.disableScroll(false))
  ).on('init')

  ready: subscribe('cordova.deviceready', ->
    Ember.Logger.debug('CDV Device Ready')
    @set('deviceReady', true)
  )

  pause: subscribe('cordova.pause', ->
    return unless @get('isMobile')

    Ember.Logger.debug('CDV Pause')
    @get('recovery').stopScheduling()
    @set('paused', true)
    @get('cm.api').hintDevicePaused()
  )

  resume: subscribe('cordova.resume', ->
    @get('recovery').startScheduling()

    return unless @get('isMobile')

    Ember.Logger.debug('CDV Resume')
    @set('paused', false)
    @get('cm.api').verifyConnectionEstablished()
  )

  offline: subscribe('cordova.offline', ->
    return unless @get('isMobile')

    Ember.Logger.debug('CDV Offline')
    @set('connectionType', null)
    @get('cm.api').networkOffline()
  )

  online: subscribe('cordova.online', ->
    return unless @get('isMobile')

    Ember.Logger.debug('CDV Online')
    @set('connectionType', navigator.connection.type)
    @get('cm.api').networkOnline()
  )

  backbtn: subscribe('cordova.backbutton', ->
    return unless @get('isMobile')

    Ember.Logger.debug('CDV Back')
    @set('appstate.menuExpanded', false)
    @trigger('backbutton')
  )

  menubtn: subscribe('cordova.menubutton', ->
    Ember.Logger.debug('CDV Menu')
  )

)

`export default CdvDeviceSupport`
