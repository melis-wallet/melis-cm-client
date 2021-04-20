import Component from '@ember/component'
import { schedule } from '@ember/runloop'

import { validator, buildValidations } from 'ember-cp-validations'

Validations = buildValidations(
  phrase: [
    validator('presence', true)
    validator('length', min: 8, max: 32)
  ]

  phraseCheck: [
    validator('confirmation', on: 'phrase')
  ]
)

SetPassPhrase= Component.extend(Validations, 

  phrase: null
  phraseCheck: null


  submitPassPhrase: ->
    if @get('validations.isValid')
      @sendAction('on-set-phrase', @get('phrase'))

  actions:
    submitNewPassPhrase: ->
      @submitPassPhrase()
)

export default SetPassPhrase
