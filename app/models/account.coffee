`import Account from 'melis-cm-svcs/models/account'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

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

ValidatedAccount = Account.extend(Validations, ValidationsHelper,


  ensureMeta: ( ->
    if cmo = @get('cmo')
      Ember.set(cmo, 'meta', {}) if Ember.isBlank(Ember.get(cmo, 'meta'))
      Ember.set(cmo, 'pubMeta', {}) if Ember.isBlank(Ember.get(cmo, 'pubMeta'))
  ).observes('cmo').on('init')

)


`export default ValidatedAccount`
