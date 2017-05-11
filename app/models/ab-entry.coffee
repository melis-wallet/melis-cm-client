`import AbEntry from 'melis-cm-svcs/models/ab-entry'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`


Validations = buildValidations(
  name: [
    validator('presence', true)
    validator('length', min: 2, max: 32)
  ]

  address: [
    validator('bitcoin-address', disabled: Ember.computed.not('model.isAddress'))
  ]

  pubId: [
    validator('melis-pubid', disabled: Ember.computed.not('model.isCm'))
  ]

  alias: [
    validator('length', min: 4, max: 63, disabled: Ember.computed.not('model.isCm'))
  ]
)

ValidatedAbEntry = AbEntry.extend(Validations, ValidationsHelper)


`export default ValidatedAbEntry`
