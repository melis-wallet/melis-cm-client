`import BaseValidator from 'ember-cp-validations/validators/base'`

NOT_A_MNEMONIC = 'validations.not-mnemonic'


MelisMnemonic = BaseValidator.extend
  creds: Ember.inject.service('cm-credentials')
  i18n: Ember.inject.service()

  validate: (value, options, model, attribute) ->
    return true if Ember.isBlank(value) && options.allowBlank

    if @get('creds').isMnemonicValid(value)
      true
    else
      @get('i18n').t(NOT_A_MNEMONIC).toString()


`export default MelisMnemonic`