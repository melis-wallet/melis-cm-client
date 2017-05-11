`import Ember from 'ember'`
`import Model from './cm-model'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`


Validations = buildValidations(
  name: [
    validator('presence', true)
    validator('length', min: 3, max: 31)
  ]
)

AccountCosigner = Model.extend(Validations, ValidationsHelper,
  name: null
  mandatory: false
  alias: null

  isValid: Ember.computed.alias('validations.isValid')
)

`export default AccountCosigner`
