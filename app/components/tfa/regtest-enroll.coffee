`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`


Validations = buildValidations(
  identifier: [
    validator('presence', true)
    validator('length', min: 5, max: 10)
  ]
)

RegtestEnroll = Ember.Component.extend(Validations, ValidationsHelper,


  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  enrollError: null
  identifier: null

  busy: false

  btnstate: null

  actions:
    enterId: ->
      if identifier = @get('identifier')
        @set 'enrollError', null
        api = @get('cm.api')

        op = (tfa) ->
          api.tfaEnrollStart({name: 'regtest', value: identifier, code: identifier}, tfa.payload)

        @set 'busy', true
        @set 'btnstate', 'executing'

        @get('aa').tfaAuth(op, "Add Email TFA").then((res) =>

          @set('btnstate', 'resolved')
          @sendAction('on-new-complete-enroll')
        ).catch((err) =>

          Ember.Logger.error "error enrolling regtest: ", err
          @set('btnstate', 'rejected')
          @set 'enrollError', err.msg
        ).finally( =>
          @set 'busy', false
        )

)

`export default RegtestEnroll`