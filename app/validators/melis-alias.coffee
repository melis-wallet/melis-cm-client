`import BaseValidator from 'ember-cp-validations/validators/base'`
`import CMCore from 'npm:melis-api-js'`

NOT_AN_ALIAS = 'validations.not-alias'

MelisAlias = BaseValidator.extend
  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  validate: (value, options, model, attribute) ->
    return true if Ember.isBlank(value) && options.allowBlank

    if !value || (value.length < 2 ) || (value.length > 36)
      return @get('i18n').t(NOT_AN_ALIAS).toString()
    else
      CMCore.C.VALID_ALIAS_REGEX.test(value)

`export default MelisAlias`