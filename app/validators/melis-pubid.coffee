`import BaseValidator from 'ember-cp-validations/validators/base'`
`import CMCore from 'npm:melis-api-js'`


NOT_A_PUBID = 'validations.not-pubid'

BitcoinAddress = BaseValidator.extend
  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  validate: (value, options, model, attribute) ->
    return true if Ember.isBlank(value) && options.allowBlank

    if !value || (value.length < 25 ) || (value.length > 36)
      return @get('i18n').t(NOT_A_PUBID).toString()
    else
      CMCore.C.VALID_PUB_ID_REGEX.test(value)

`export default BitcoinAddress`