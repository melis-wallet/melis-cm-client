import Component from '@ember/component'
import { get } from '@ember/object'
import { isBlank } from '@ember/utils'
import { A } from '@ember/array'

SelectLocale = Component.extend(


  selected: null

  locales: ( ->
    if (i18n = @get('i18n')) && !isBlank(i18n.get('locales'))
      @get('i18n.locales').uniq().map((l) ->
        return {id: l, text: i18n.t("locales.#{l}")}
      )
    else
      A()
  ).property('i18n.locales.[]', 'selected')

  locale: ( ->
    @get('locales').findBy('id', @get('selected'))
  ).property('locales', 'selected')


  actions:
    changeLocale: (locl)->
      @sendAction('on-change', get(locl, 'id'))
)

export default SelectLocale