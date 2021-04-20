import Component from '@ember/component'

import { validator, buildValidations } from 'ember-cp-validations'
import { task } from 'ember-concurrency'
import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'

DEVICES_WITH_TOKEN = ['email', 'xmpp', 'sms', 'telegram', 'matrix']
SEND_GUARD = 10000

Validations = buildValidations(
  token: [
    validator('presence', true)
    validator('length', min: 5, max: 8)
    validator('number', allowString: true, integer: true)
  ]
)


EnterToken = Component.extend(Validations, 

  device: null
  token: null

  sendButton: false
  tokenSent: false

  running: false
  done: false

  isDisabled: ( -> 
    @get('running') || @get('done')
  ).property('running', 'done')

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
      if @get('validations.isValid') && (token = @get('token')) && (device = @get('device'))
        @sendAction('on-valid-token', device, token)

)

export default EnterToken