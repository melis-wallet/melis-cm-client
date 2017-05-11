I18nInitializer = {
  name: 'i18n'

  initialize: (instance) ->
    i18n = instance.lookup('service:i18n')
    session = instance.lookup('service:cm-session')

    locale = session.get('locale')
    if !i18n.get('locales').includes(locale)
      session.set('locale', session.get('defaultLocale'))
}

`export default I18nInitializer`