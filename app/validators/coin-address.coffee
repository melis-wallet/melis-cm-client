import { inject as service } from '@ember/service'
import { isBlank } from '@ember/utils'

import BaseValidator from 'ember-cp-validations/validators/base'
import Logger from 'melis-cm-svcs/utils/logger'

NOT_AN_ADDRESS = 'validations.not-coin'

CoinAddress = BaseValidator.extend
  cm: service('cm-session')
  coinsvc: service('cm-coin')
  i18n: service()

  validate: (value, options, model, attribute) ->
    return true if isBlank(value) && options.allowBlank
    Logger.warn("Address validation without a coin") if !options.coin

    addr =
      if options.allowURI
        @get('coinsvc').addressFromUri(value, options.coin)
      else
        value

    try
      if @get('coinsvc').validateAddress(addr?.trim(), options.coin)
        true
      else
        @get('i18n').t(NOT_AN_ADDRESS).toString()
    catch
      @get('i18n').t(NOT_AN_ADDRESS).toString()



export default CoinAddress