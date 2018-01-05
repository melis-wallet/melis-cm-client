`import CMCore from 'npm:melis-api-js'`
`import CmSessionService from 'melis-cm-svcs/services/cm-session'`
`import config from '../config/environment'`
`import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'`

DEFAULT_LOCALE = 'en'

C = CMCore.C

SessionService = CmSessionService.extend(
  moment: Ember.inject.service()
  i18n: Ember.inject.service()
  routing:  Ember.inject.service('-routing')

  defaultLocale: DEFAULT_LOCALE


  webUrlFor: (routeName, model, hash) ->
    routeSeg = @get('routing').generateURL(routeName, [model], hash)
    (config.APP.publicUrl || '') + routeSeg


  localeChange: ( ->
    if locale = @get('locale')
      console.log "- Changed locale: ", locale

      if !@get('i18n.locales').includes(locale)
        locale = DEFAULT_LOCALE

      @set('i18n.locale', locale)
      @get('moment').changeLocale(locale)
  ).observes('locale').on('init')


  resetApp: ->
    waitTime(650).then( -> window.location.reload())
)

`export default SessionService`
