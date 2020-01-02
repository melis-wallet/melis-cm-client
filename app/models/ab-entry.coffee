import { computed } from '@ember/object'
import { alias } from '@ember/object/computed'

import AbEntry from 'melis-cm-svcs/models/ab-entry'
import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'

Validations = buildValidations(
  name: [
    validator('presence', true)
    validator('length', min: 2, max: 32)
  ]

  coin: [
    validator('presence', presence: true, on: 'address')
  ]

  address: [
    validator('coin-address', disabled: computed.not('model.isAddress'), coin: alias('model.coin'))
  ]

  pubId: [
    validator('melis-pubid', disabled: computed.not('model.isCm'))
  ]

  alias: [
    validator('length', min: 4, max: 63, disabled: computed.not('model.isCm'))
  ]
)

ValidatedAbEntry = AbEntry.extend(Validations, ValidationsHelper)


export default ValidatedAbEntry
