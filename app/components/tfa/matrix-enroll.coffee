import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import { validator, buildValidations } from 'ember-cp-validations'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

	
REGEXP_DOMAIN = "((?!-)[A-Za-z0-9\\-]{1,63}(?!-)\\.)+[A-Za-z]{2,}"
REGEXP = new RegExp("^@[a-zA-Z0-9_=/\\-\\.]+\\:" + REGEXP_DOMAIN + "$")

Validations = buildValidations(
  matrixAddress: [
    validator('presence', true)
    validator('length', min: 3, max: 64)
    validator('format', regex: REGEXP, messageKey: 'tfa.matrix.invalid')
  ]
)

MatrixEnroll = Component.extend(Validations, 


  cm: service('cm-session')
  aa: service('aa-provider')

  enrollError: null
  matrixAddress: null

  busy: false

  btnstate: null

  currentDevice: null
  currentResponse: null

  apiOps: taskGroup().drop()


  enrollFinish: task( (device, token)->
    @set 'enrollError', null
    api = @get('cm.api')

    try
      res = yield api.tfaEnrollFinish(name: device.name, value: device.value, code: token)
      @sendAction('on-new-complete-enroll', res.device)
    catch error
      Logger.error "Error doing enroll finish: ", error
      @set 'enrollError', error.msg

  ).group('apiOps')

  enrollMatrix: task( (device)->
    if address = @get('matrixAddress')
      api = @get('cm.api')
      @set 'enrollError', null

      op = (tfa) ->
        api.tfaEnrollStart({name: 'matrix', value: address}, tfa.payload)

      @setProperties
        busy: true
        btnstate: 'executing'

      try
        res = yield @get('aa').tfaAuth(op, "Add Matrix TFA")
        @set('btnstate', 'resolved')
        #@sendAction('on-new-enroll')
        @set 'currentDevice', get(res, 'device')
        if (rawvalue = get(res, 'value'))
          @set 'currentResponse', JSON.parse(rawvalue)
      catch error
        if error.ex == 'CmInvalidTfaException'
          @set  'enrollError', @get('i18n').t('tfa.matrix.invalid')
        else
          @set 'enrollError', error.msg
        Logger.error "error enrolling xmpp: ", error
        @set('btnstate', 'rejected')

      @set 'busy', false
  )

  actions:

    enrollFinish: (device, code) ->
      if device && code
        @get('enrollFinish').perform(device, code)

    enterAddress: ->
      @get('enrollMatrix').perform()

    cancelEnroll: ->
      @setProperties
        enrollError: null
        matrixAddress: null

)

export default MatrixEnroll
