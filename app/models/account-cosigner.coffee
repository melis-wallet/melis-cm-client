import { alias } from '@ember/object/computed'

import Model from './cm-model'
import { validator, buildValidations } from 'ember-cp-validations'


Validations = buildValidations(
  name: [
    validator('presence', true)
    validator('length', min: 3, max: 31)
  ]
)

AccountCosigner = Model.extend(Validations, 
  name: null
  mandatory: false
  alias: null

  isValid: alias('validations.isValid')
)

export default AccountCosigner
