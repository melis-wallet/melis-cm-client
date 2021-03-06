import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { validator, buildValidations } from 'ember-cp-validations'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  xmppAddress: [
    validator('presence', true)
    validator('length', min: 4, max: 64)
    validator('format', type: 'email', messageKey: 'tfa.xmpp.invalid')
  ]
)

XmppEnroll = Component.extend(Validations, 

  cm: service('cm-session')
  aa: service('aa-provider')

  enrollError: null
  xmppAddress: null

  busy: false

  btnstate: null

  apiOps: taskGroup().drop()

  enrollXmpp: task( (device)->
    if address = @get('xmppAddress')
      api = @get('cm.api')
      @set 'enrollError', null

      op = (tfa) ->
        api.tfaEnrollStart({name: 'xmpp', value: address}, tfa.payload)

      @setProperties
        busy: true
        btnstate: 'executing'

      try
        res = yield @get('aa').tfaAuth(op, "Add XMPP TFA")
        @set('btnstate', 'resolved')
        @sendAction('on-new-complete-enroll')
      catch error
        if error.ex == 'CmInvalidMailException'
          @set  'enrollError', @get('i18n').t('tfa.xmpp.invalid')
        else
          @set 'enrollError', error.msg
        Logger.error "error enrolling xmpp: ", error
        @set('btnstate', 'rejected')

      @set 'busy', false
  )

  actions:
    enterAddress: ->
      @get('enrollXmpp').perform()

    cancelEnroll: ->
      @setProperties
        enrollError: null
        xmppAddress: null

)

export default XmppEnroll
