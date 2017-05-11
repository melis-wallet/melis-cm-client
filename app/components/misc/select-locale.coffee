`import Ember from 'ember'`


SelectLocale = Ember.Component.extend(


  selected: null

  locales: ( ->
    if (i18n = @get('i18n')) && !Ember.isBlank(i18n.get('locales'))
      @get('i18n.locales').uniq().map((l) ->
        return {id: l, text: i18n.t("locales.#{l}")}
      )
    else
      Ember.A()
  ).property('i18n.locales.[]', 'selected')

  locale: ( ->
    @get('locales').findBy('id', @get('selected'))
  ).property('locales', 'selected')


  actions:
    changeLocale: (locl)->
      @sendAction('on-change', Ember.get(locl, 'id'))




)

`export default SelectLocale`