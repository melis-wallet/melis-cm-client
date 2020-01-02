import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


TFAPrompt = Component.extend(

  cm: service('cm-session')
  aa: service('aa-provider')

  validDevices: alias('aa.tfaValidDevices')
  activeDevice: null

  infoText: null

  running: false

  apiOps: taskGroup().drop()

  sendToken: task( (device)->
    @set('activeDevice', null)
    @set('infoText', null)

    api = @get('cm.api')

    if device
      try
        yield api.tfaAuthStart(device)
        @set('infoText', @get('i18n').t('tfa.actions.token-sent'))
        @set('activeDevice', device)
      catch error
        Logger.error "TF Auth Error: ", error
        @set('infoText', @get('i18n').t('tfa.actions.error'))
  ).group('apiOps')


  actions:
    validToken: (device, token) ->
      if token
        data = {name: device.name, value: device.value, code: token}
        @sendAction('on-valid-tfa', data)

    sendToken: (device) ->
      @get('sendToken').perform(device)
)

export default TFAPrompt