`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`


PrimaryDevice = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  creds: Ember.inject.service('cm-credentials')
  aa: Ember.inject.service('aa-provider')
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
      res = yield @get('aa').tfaOrLocalPin(op)

    catch e
      @set 'error', e.msg
      Ember.Logger.error "Make Primary error: ", e

  ).group('apiOps')

  makePrimary: task((device) ->
    api = @get('cm.api')

    op = (tfa) ->
      api.devicePromoteToPrimary(device, tfa.payload)

    try
      res = yield @get('aa').tfaOrLocalPin(op)
      if res && (date = Ember.get(res, 'dateExecutable'))
        @set 'dateExecutable', date

    catch e
      @set 'error', e.msg
      Ember.Logger.error "Make primary error: ", e
  ).group('apiOps')


  getRecovery: task( ->
    try
      data  = yield @get('cm.api').deviceGetRecoveryHours()
      if h = Ember.get(data, 'hours')
        @set('recoveryDays', Math.round(h / 24))
        @set('recoveryConfirm', false)
      console.error data
    catch e
      Ember.Logger.error "Error: ", e
  )


  changeDeviceName: task((name) ->
    try
      yield @get('cm').deviceChangeName(name)
    catch e
      Ember.Logger.error "Dev change name error: ", e
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


    makePrimary: ->
      if device = @get('creds.deviceId')
        @get('makePrimary').perform(device)

    changeDeviceName: (name) ->
      @get('changeDeviceName').perform(name) if name
)

`export default PrimaryDevice`
