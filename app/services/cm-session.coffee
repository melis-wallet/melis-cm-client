import Service, { inject as service } from '@ember/service'

import API from 'melis-api-js'

import CmSessionService from 'melis-cm-svcs/services/cm-session'
import config from '../config/environment'
import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'

DEFAULT_LOCALE = 'en'

SessionService = CmSessionService.extend(
  moment: service()
  i18n: service()
  routing: service('-routing')

  defaultLocale: DEFAULT_LOCALE


  webUrlFor: (routeName, model, hash) ->
    routeSeg = @get('routing').generateURL(routeName, [model], hash)
    (config.APP.publicUrl || '') + routeSeg


  localeChange: ( ->
    if locale = @get('locale')
      console.log "- Changed locale: ", locale

      if !(@get('i18n.locales')?.includes(locale))
        locale = DEFAULT_LOCALE

      @set('i18n.locale', locale)
      @get('moment').changeLocale(locale)
  ).observes('locale', 'i18n.locales.[]').on('init')


  resetApp: ->
    waitTime(650).then( -> window.location.reload())
)

export default SessionService
