`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

TFAPrompt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  validDevices: Ember.computed.alias('aa.tfaValidDevices')
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
        console.error "TF Auth Error: ", error
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

`export default TFAPrompt`