`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, taskGroup } from 'ember-concurrency'`


Validations = buildValidations(
  phoneNumber: [
    validator('presence', true)
    validator('length', min: 7, max: 13)
    validator('format', regex: /^\+[\d ]+$/, messageKey: 'tfa.sms.invalid')
  ]
)

SmsEnroll = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  enrollError: null
  phoneNumber: null

  busy: false

  btnstate: null

  apiOps: taskGroup().drop()

  enrollSms: task( (device)->
    if address = @get('phoneNumber')
      api = @get('cm.api')
      @set 'enrollError', null

      address = address.replace(/ /g,'')

      op = (tfa) ->
        api.tfaEnrollStart({name: 'sms', value: address}, tfa.payload)

      @setProperties
        busy: true
        btnstate: 'executing'

      try
        res = yield @get('aa').tfaAuth(op, "Add SMS TFA")
        @set('btnstate', 'resolved')
        @sendAction('on-new-complete-enroll')
      catch error
        if error.ex == 'xxxx'
          @set  'enrollError', @get('i18n').t('tfa.sms.invalid')
        else
          @set 'enrollError', error.msg
        Ember.Logger.error "error enrolling sms: ", error
        @set('btnstate', 'rejected')

      @set 'busy', false
  )

  actions:
    enterSms: ->
      @get('enrollSms').perform()

    cancelEnroll: ->
      @setProperties
        enrollError: null
        phoneNumber: null




)

`export default SmsEnroll`