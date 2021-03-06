import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, filter } from '@ember/object/computed'
import { get, set } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


ManageNlock = Component.extend(


  cm: service('cm-session')
  recovery: service('cm-recovery-info')
  aa: service('aa-provider')
  i18n: service()
  device: service('device-support')

  lockTimeOpts: [
    {value: 180, label: 'view.nlock.time.6mo'}
    {value: 90, label: 'view.nlock.time.3mo'}
    {value: 30, label: 'view.nlock.time.1mo'}
    {value: 0, label: 'view.nlock.time.disabled'}
  ]

  selectedLockOpt: ( ->
    value = @get('lockTimeOpts').findBy('value', @get('lockTime'))
    if value
      value
    else
      {value: @get('lockTime'), label: 'view.nlock.time.current'}


  ).property('lockTime')


  lockTime: alias('account.cmo.lockTimeDays')
  unspents: alias('account.recoveryInfo.expiring')
  recoveryInfo: alias('account.recoveryInfo.current')

  account: null

  error: false

  filenameBase: '-recovery.json'

  apiOps: taskGroup().drop()

  expiring: filter('unspents', (e) ->
    ex = get(e, 'timeExpire')
    (ex < moment().add(EXPIRE_THRESH, 'days').valueOf()) if ex
  )

  firstExpiring: alias('expiring.firstObject')


  getCurrentValue: task( ->
    if account = @get('account')
      try
        res = yield  @get('cm.api').getLocktimeDays(account.get('cmo'))
        if res && (days = get(res, 'lockTimeDays'))
          @set 'lockTime', days
      catch error
        Logger.error error

    else

  )

  getExpiring: task( ->
    if account = @get('account')
      res = yield  @get('cm.api').getExpiringUnspents(account.get('cmo'))
      if res && (list = get(res, 'list'))
        @set 'unspents', list
    else

  )

  getUnspents: task( ->
    if account = @get('account')
      res = yield  @get('cm.api').getUnspents(account.get('cmo'))
      if res && (list = get(res, 'list'))
        @set 'unspents', list
    else

  )


  getRecoveryInfo: task( ->
    if account = @get('account')
      try
        yield @get('recovery').getRecoveryInfo(account)
      catch error
        Logger.error "Error refreshing: ", error

  ).group('apiOps')


  changeLockTime: task( (days) ->

    if (account = @get('account'))
      op = (tfa) =>
        @get('cm.api').setLocktimeDays(account.get('cmo'), days, tfa.payload)

      try
        res = yield @get('aa').tfaOrLocalPin(op)
        if res && (days = get(res, 'lockTimeDays'))
          @set 'lockTime', days
      catch error
        Logger.error "Error refreshing: ", error
  ).group('apiOps')


  accountChanged: (->
    @setProperties
      unspents: null
      error: false
  ).observes('account')

  actions:
    changeLockTime: (value) ->
      @get('changeLockTime').perform(value.value)


    getExpiring: ->
      @get('getExpiring').perform()
    getRecovery: ->
      @get('getRecoveryInfo').perform()


    rotateAll: (inputs) ->
      @get('rotateInputs').perform(inputs)


    confirmRotation: ->
      if (tx = @get('preparedTx'))
        @get('confirmRotation').perform(tx)

    cancelRotation: ->
      if (tx = @get('preparedTx'))
        @get('cancelRotation').perform(tx)

)

export default ManageNlock
