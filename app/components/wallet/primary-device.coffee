import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


PrimaryDevice = Component.extend(

  cm: service('cm-session')
  creds: service('cm-credentials')
  aa: service('aa-provider')

  apiOps: taskGroup().enqueue()

  error: null
  dateExecutable: null

  recoveryDays: null
  maxRecoveryDays: 30
  recoveryConfirm: false

  updateRecovery: task((days) ->
    api = @get('cm.api')

    op = (tfa) ->
      api.deviceSetRecoveryHours(days*24, tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op)

    catch e
      @set 'error', e.msg
      Logger.error "Update Recovery error: ", e

  ).group('apiOps')

  makePrimary: task((device) ->
    api = @get('cm.api')

    op = (tfa) ->
      api.devicePromoteToPrimary(device, tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op)
      if res && (date = get(res, 'dateExecutable'))
        @set 'dateExecutable', date

    catch e
      @set 'error', e.msg
      Logger.error "Make primary error: ", e
  ).group('apiOps')



  cancelPrimary: task( ->
    api = @get('cm.api')

    op = (tfa) ->
      console.debug('cancelprim', tfa.payload)
      api.deviceCancelPromotion(tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op)
      if res && (date = get(res, 'dateExecutable'))
        @set 'dateExecutable', date

    catch e
      @set 'error', e.msg
      Logger.error "Cancel primary error: ", e
  ).group('apiOps')




  getRecovery: task( ->
    try
      data  = yield @get('cm.api').deviceGetRecoveryHours()
      if h = get(data, 'hours')
        @set('recoveryDays', Math.round(h / 24))
        @set('recoveryConfirm', false)
    catch e
      Logger.error "Error: ", e
  )


  changeDeviceName: task((name) ->
    try
      yield @get('cm').deviceChangeName(name)
    catch e
      Logger.error "Dev change name error: ", e
  )

  getInfo: ( ->
    @get('getRecovery').perform()
  ).on('init')

  recoveryChanged:  ( ->
    @set('recoveryConfirm', true)
  ).observes('recoveryDays')

  actions:
    updateRecovery: ->
      @get('updateRecovery').perform(@get('recoveryDays'))


    cancelPrimary: ->
      @get('cancelPrimary').perform()

    makePrimary: ->
      if device = @get('creds.deviceId')
        @get('makePrimary').perform(device)

    changeDeviceName: (name) ->
      @get('changeDeviceName').perform(name) if name
)

export default PrimaryDevice
