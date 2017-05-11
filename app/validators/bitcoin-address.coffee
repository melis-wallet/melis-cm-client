`import BaseValidator from 'ember-cp-validations/validators/base'`

NOT_AN_ADDRESS = 'validations.not-bitcoin'

BitcoinAddress = BaseValidator.extend
  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  validate: (value, options, model, attribute) ->
    return true if Ember.isBlank(value) && options.allowBlank

    if !value || (value.length < 25 ) || (value.length > 36)
      return @get('i18n').t(NOT_AN_ADDRESS).toString()

    if @get('cm.api').validateAddress(value)
      true
    else
      @get('i18n').t(NOT_AN_ADDRESS).toString()


`export default BitcoinAddress`