`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, taskGroup } from 'ember-concurrency'`


Validations = buildValidations(
  emailAddress: [
    validator('presence', true)
    validator('length', min: 4, max: 64)
    validator('format', type: 'email')
  ]
)

EmailEnroll = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  enrollError: null
  emailAddress: null

  busy: false

  btnstate: null

  apiOps: taskGroup().drop()

  enrollEmail: task( ()->
    if address = @get('emailAddress')
      api = @get('cm.api')
      @set 'enrollError', null

      op = (tfa) ->
        api.tfaEnrollStart({name: 'email', value: address}, tfa.payload)

      @setProperties
        busy: true
        btnstate: 'executing'

      try
        res = yield @get('aa').tfaAuth(op, "Add Email TFA")
        @set('btnstate', 'resolved')
        @sendAction('on-new-complete-enroll')
      catch error
        if error.ex == 'CmInvalidMailException'
          @set  'enrollError', @get('i18n').t('tfa.email.invalid')
        else
          @set 'enrollError', error.msg
        Ember.Logger.error "error enrolling email: ", error
        @set('btnstate', 'rejected')

      @set 'busy', false
  )

  actions:
    enterEmail: ->
      @get('enrollEmail').perform()

    cancelEnroll: ->
      @setProperties
        enrollError: null
        emailAddress: null


)

`export default EmailEnroll`