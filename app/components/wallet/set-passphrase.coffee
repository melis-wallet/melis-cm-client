import Component from '@ember/component'
import { schedule } from '@ember/runloop'

import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'

Validations = buildValidations(
  phrase: [
    validator('presence', true)
    validator('length', min: 8, max: 32)
  ]

  phraseCheck: [
    validator('confirmation', on: 'phrase')
  ]
)

SetPassPhrase= Component.extend(Validations, ValidationsHelper,

  phrase: null
  phraseCheck: null

  listenKeypress: (->
    schedule 'afterRender', this, (->
      # ember-rapid-forms seems to have an 'autofocus' attribute, it just doesn't do anything
      @.$('input#phrase_input').focus()
      # listen to keypresses to submit with enter pinCheck /ugly/fixme/
      @.$('input#phrase_check').keypress( (e) =>
        if (e.which == 10 || e.which == 13)
          @submitPassPhrase()
      )
    )
  ).on('didInsertElement')

  phraseChanged: (->
    @validate()
  ).observes('phrase')

  submitPassPhrase: ->
    if @get('isValid')
      @sendAction('on-set-phrase', @get('phrase'))

  actions:
    submitNewPassPhrase: ->
      @submitPassPhrase()
)

export default SetPassPhrase
