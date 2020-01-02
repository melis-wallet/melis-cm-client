import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { filterBy } from '@ember/object/computed'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

ChangePin = Component.extend(

  changing: false
  success: false
  error: false

  cm: service('cm-session')
  aaProvider: service('aa-provider')
  fpa: service('fingerprint-auth')

  apiOps: taskGroup().drop()

  setNewPIN: task((newPin) ->
    @setProperties(success: false, error: false)

    try
      op = (data) =>
        @get('cm').changePin(data.pin, newPin)

      res = yield  @get('aaProvider').askLocalPin(op, 'Authorize Change Pin', true, true)
      if @get('fpa.successfullyEnrolled')
        try
          yield @get('fpa').enroll(newPin)
        catch e
          # the stored pin would not match
          @get('fpa').disable()


      @set('success', true)
      @set('changing', false)
    catch error
      @set('error', true)
      Logger.error('Set pin failed: ', error)

  ).group('apiOps')


  actions:
    toggleChange: ->
      @toggleProperty('changing')

    setNewPIN: (newPin) ->
      @get('setNewPIN').perform(newPin)

)

export default ChangePin
