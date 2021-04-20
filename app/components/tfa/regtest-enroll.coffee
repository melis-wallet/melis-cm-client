import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { validator, buildValidations } from 'ember-cp-validations'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  identifier: [
    validator('presence', true)
    validator('length', min: 5, max: 10)
  ]
)

RegtestEnroll = Component.extend(Validations, 

  cm: service('cm-session')
  aa: service('aa-provider')

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

        @setProperties
          busy: true
          btnstate: 'executing'

        @get('aa').tfaAuth(op, "Add Email TFA").then((res) =>
          @set('btnstate', 'resolved')
          @sendAction('on-new-complete-enroll')
        ).catch((err) =>

          Logger.error "error enrolling regtest: ", err
          @setProperties
            btnstate: 'rejected'
            enrollError, err.msg
        ).finally( =>
          @set 'busy', false
        )

)

export default RegtestEnroll