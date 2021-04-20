import { isBlank } from '@ember/utils'
import { get, set } from '@ember/object'
import { alias } from '@ember/object/computed'

import Account from 'melis-cm-svcs/models/account'
import { validator, buildValidations } from 'ember-cp-validations'

Validations = buildValidations(
  name: [
    validator('presence', true)
    validator('length', min: 1, max: 32)
  ]

  'cmo.pubMeta.name': [
    validator('length', min: 1, max: 32, allowBlank: true)
  ]


  'cmo.pubMeta.address': [
    validator('length',  max: 1024, allowBlank: true)
  ]


  'cmo.pubMeta.profile': [
    validator('length',  max: 1024, allowBlank: true)
  ]

)

ValidatedAccount = Account.extend(Validations, 

  ensureMeta: ( ->
    if cmo = @get('cmo')
      set(cmo, 'meta', {}) if isBlank(get(cmo, 'meta'))
      set(cmo, 'pubMeta', {}) if isBlank(get(cmo, 'pubMeta'))
  ).observes('cmo').on('init')
  
  isValid: alias('validations.isValid')
)


export default ValidatedAccount
