import { inject as service } from '@ember/service'
import { isBlank } from '@ember/utils'

import BaseValidator from 'ember-cp-validations/validators/base'

NOT_A_MNEMONIC = 'validations.not-mnemonic'


MelisMnemonic = BaseValidator.extend
  creds: service('cm-credentials')
  i18n: service()

  validate: (value, options, model, attribute) ->
    return true if isBlank(value) && options.allowBlank

    if @get('creds').isMnemonicValid(value)
      true
    else
      @get('i18n').t(NOT_A_MNEMONIC).toString()


export default MelisMnemonic