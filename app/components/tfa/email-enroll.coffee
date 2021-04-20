import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { validator, buildValidations } from 'ember-cp-validations'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'



Validations = buildValidations(
  emailAddress: [
    validator('presence', true)
    validator('length', min: 4, max: 64)
    validator('format', type: 'email')
  ]
)

EmailEnroll = Component.extend(Validations, 

  cm: service('cm-session')
  aa: service('aa-provider')

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
        Logger.error "error enrolling email: ", error
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

export default EmailEnroll