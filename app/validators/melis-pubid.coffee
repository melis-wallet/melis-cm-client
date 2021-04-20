import { inject as service } from '@ember/service'
import { isBlank } from '@ember/utils'

import BaseValidator from 'ember-cp-validations/validators/base'
import CMCore from 'melis-api-js'


NOT_A_PUBID = 'validations.not-pubid'

BitcoinAddress = BaseValidator.extend
  cm: service('cm-session')
  i18n: service()

  validate: (value, options, model, attribute) ->
    return true if isBlank(value) && options.allowBlank

    if !value || (value.length < 25 ) || (value.length > 36)
      return @get('i18n').t(NOT_A_PUBID).toString()
    else
      CMCore.C.VALID_PUB_ID_REGEX.test(value)

export default BitcoinAddress