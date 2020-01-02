
I18nInitializer = {
  name: 'i18n'

  initialize: (application) ->
    application.inject('controller', 'i18n', 'service:i18n')
    application.inject('component', 'i18n', 'service:i18n')

}


export default I18nInitializer