`import Ember from 'ember'`
`import StyleBody from 'ember-leaf-core/mixins/leaf-style-body'`

ApplicationRoute = Ember.Route.extend(StyleBody,
  #i18n: Ember.inject.service()
  cdv: Ember.inject.service('device-support')

  classNames: ['theme-melis']


  beforeModel: ->
    @get('cdv')
    #console.error @get('i18n.locale')
    #@set('i18n.locale', 'en');
    #Ember.I18n = @get('i18n')


  actions:
    error: (e) ->
      if handler = @get('cm.report_error')
        handler(e)

)

`export default ApplicationRoute`
