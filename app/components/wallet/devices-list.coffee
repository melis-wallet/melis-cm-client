import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { A } from '@ember/array'
import { get } from '@ember/object'
import { isEmpty } from '@ember/utils'

import Configuration from 'melis-cm-svcs/utils/configuration'
import { task, taskGroup } from 'ember-concurrency'
import ModalAlerts from '../../mixins/modal-alerts'

import Logger from 'melis-cm-svcs/utils/logger'


DevicesList = Component.extend(ModalAlerts,

  cm: service('cm-session')
  creds: service('cm-credentials')
  aa: service('aa-provider')

  devices: null
  apiOps: taskGroup().drop()

  reloadTrigger: false

  changeDeviceName: task((name, deviceId) ->
    try
      if deviceId == @get('creds.deviceId')
        yield @get('cm').deviceChangeName(name)
      else
        yield @get('cm.api').deviceUpdate(deviceId, name)
      yield  @get('getDevices').perform()
    catch e
      Logger.error "Dev change name error: ", e
  ).group('apiOps')

  getDevices: task( ->
    try
      res = yield @get('cm.api').devicesGet()
      @set 'devices', A(res.list)
    catch e
      Logger.error "Dev list error: ", e
  ).drop()


  deleteDevices: task((list) ->
    api = @get('cm.api')

    op = (tfa) ->
        api.devicesDelete(list, tfa.payload)
    try
      ok = yield @showModalAlert(
        type: 'warning'
        title: 'wallet.devices.list.wdelete.title'
        caption: 'wallet.devices.list.wdelete.caption'
      )
      return unless ok == 'ok'

      res = yield @get('aa').tfaOrLocalPin(op)
      yield @get('getDevices').perform()
    catch e
      @set 'error', e.msg
      Logger.error "Dev delete error: ", e
  ).group('apiOps')

  promoteToPrimary: task((device) ->
    api = @get('cm.api')
    op = (tfa) ->
        api.devicePromoteToPrimary(device, tfa.payload)

    try
      ok = yield @showModalAlert(
        type: 'warning'
        title: 'wallet.devices.list.wpromote.title'
        caption: 'wallet.devices.list.wpromote.caption'
      )
      return unless ok == 'ok'

      res = yield @get('aa').tfaOrLocalPin(op)
    catch e
      @set 'error', e.msg
      Logger.error "Dev promote error: ", e
  ).group('apiOps')

  # this could be much better TODO
  needsRefresh: ( ->
    if !@get('reloadTrigger')
      @get('getDevices').perform()
  ).observes('reloadTrigger')

  setup: (->
    @get('reloadTrigger')
    @get('getDevices').perform()
    @get('creds.deviceName')
  ).on('didInsertElement').observes('creds.deviceName')

  actions:
    deleteAllDevices: ->
      devices = @get('devices')?.map((d) -> get(d, 'deviceId')).removeObject(@get('cm.credentials.deviceId'))
      unless isEmpty(devices)
        @get('deleteDevices').perform(devices)

    deleteDevice: (d) ->
      @get('deleteDevices').perform(d)

    promoteToPrimary: (d) ->
      @get('promoteToPrimary').perform(d)

    changeDeviceName: (name, id ) ->
      @get('changeDeviceName').perform(name, id)


)

export default DevicesList
