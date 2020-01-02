import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


StreamEvt = Component.extend(

  cm: service('cm-session')
  aa: service('aa-provider')

  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: alias('entry.content')

  label: ( ->
    @get('event.cmo.name') || @get('event.cmo.deviceId')
  ).property('event.cmo.name', 'event.cmo.deviceId')

  canceled: alias('event.cmo.canceled')

  cancelRecovery: task( ->
    api = @get('cm.api')
    @set 'error', false

    op = (tfa) ->
      api.tfaAuthValidate(tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op, "Reset TFA Devices")
      @set 'doneRequest', true
    catch error
      Logger.error('Error resetting TFA', error)
      @set 'error', true
  )

  actions:
    cancelRecovery: ->
      @get('cancelRecovery').perform()
)


export default StreamEvt
