`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

StreamEvt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: Ember.computed.alias('entry.content')

  label: ( ->
    @get('event.cmo.name') || @get('event.cmo.deviceId')
  ).property('event.cmo.name', 'event.cmo.deviceId')

  canceled: Ember.computed.alias('event.cmo.canceled')

  cancelRecovery: task( ->
    api = @get('cm.api')
    @set 'error', false

    op = (tfa) ->
      api.tfaAuthValidate(tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op, "Reset TFA Devices")
      @set 'doneRequest', true
    catch error
      Ember.Logger.error('Error resetting TFA', error)
      @set 'error', true
  )

  actions:
    cancelRecovery: ->
      @get('cancelRecovery').perform()
)


`export default StreamEvt`
