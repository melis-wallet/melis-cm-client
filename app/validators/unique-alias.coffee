import { inject as service } from '@ember/service'
import { isBlank } from '@ember/utils'

import BaseValidator from 'ember-cp-validations/validators/base'

DUPLICATE_ALIAS = 'validations.duplicate-alias'

UniqueAlias = BaseValidator.extend
  cm: service('cm-session')
  i18n: service()

  validate: (value, options, model, attribute) ->
    return true if isBlank(value) && options.allowBlank

    @get('cm.api').aliasIsAvailable(value).then((res) =>
      if res && res.avail
        return true
      else
        return @get('i18n').t(DUPLICATE_ALIAS).toString()
    )

export default UniqueAlias