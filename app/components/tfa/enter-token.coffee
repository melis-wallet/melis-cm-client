import Component from '@ember/component'

import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import { task } from 'ember-concurrency'
import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'

DEVICES_WITH_TOKEN = ['email', 'xmpp', 'sms', 'telegram']
SEND_GUARD = 10000

Validations = buildValidations(
  token: [
    validator('presence', true)
    validator('length', min: 5, max: 8)
    validator('number', allowString: true, integer: true)
  ]
)


EnterToken = Component.extend(Validations, ValidationsHelper,

  device: null
  token: null

  sendButton: false
  tokenSent: false

  running: false

  showSendButton: ( ->
    @get('sendButton') && DEVICES_WITH_TOKEN.includes(@get('device.name'))
  ).property('sendButton')


  showForm: ( ->
    @get('tokenSent') || !@get('showSendButton')
  ).property('tokenSent', 'showSendButton')


  sendToken: task( ->
    if device = @get('device')
      @set('tokenSent', true)
      @sendAction('on-send-token', device)
      yield waitTime(SEND_GUARD)
  ).drop()

  actions:
    sendToken: ->
      @get('sendToken').perform()

    enterToken: ->
      if @get('isValid') && (token = @get('token')) && (device = @get('device'))
        @sendAction('on-valid-token', device, token)

)

export default EnterToken