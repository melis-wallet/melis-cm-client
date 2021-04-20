import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { filter, filterBy } from '@ember/object/computed'
import { get } from '@ember/object'
import { isEmpty } from '@ember/utils'

import CMCore from 'melis-api-js'
import { task, taskGroup } from 'ember-concurrency'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'

import Logger from 'melis-cm-svcs/utils/logger'

NlockExpiring = Component.extend(

  cm: service('cm-session')
  recovery: service('cm-recovery-info')
  aaProvider: service('aa-provider')
  ptxsvc: service('cm-ptxs')

  account: null
  unspents: null
  error: false

  validUnspents: filter('unspents', ((i) ->
    (i.blockMature > 0) &&
    (i.timeExpire < moment().add(1, 'week').valueOf())
  ))

  checkedUnspents: filterBy('validUnspents', 'checked', true)

  activeUnspents: ( ->
    if isEmpty(@get('checkedUnspents')) then @get('validUnspents') else @get('checkedUnspents')
  ).property('validUnspents', 'checkedUnspents')

  preparedTx: null
  doneTx: null


  apiOps: taskGroup().drop()
  refreshOps: taskGroup().drop()

  confirmRotation: task( (tx) ->
    @setProperties
      error: false
      doneTx: false

    try
      res = yield @get('ptxsvc').ptxSign(tx)
      @setProperties
        error: false
        preparedTx: null
        doneTx: true
    catch error
      @set('error', true)
      Logger.error "Error signing: ", error

    @get('delayRefresh').perform()
  ).group('apiOps')


  cancelRotation: task( (tx) ->
    @setProperties
      error: false
      doneTx: false

    try
      res = yield @get('ptxsvc').ptxCancel(tx)
      @setProperties
        error: false
        preparedTx: null
        doneTx: null
    catch error
      @set('error', true)
      Logger.error "Error cancelling: ", error

    @get('refresh').perform()
  ).group('apiOps')


  rotateInputs: task( (inputs) ->
    @setProperties
      error: false
      doneTx: false

    return if isEmpty(inputs)
    if (account = @get('account'))
      unspents = inputs.map((i) -> {hash: i.tx, n: i.n })

      try
        state = yield @get('cm.api').payPrepare(account.get('cmo'),
          null,
          autoSignIfValidated: true, disableRbf: true, unspents: unspents)
        ptx = @get('ptxsvc').ptxFromState(state, @get('account'))
        @set 'preparedTx', ptx

      catch error
        @set('error', true)
        Logger.error "Error rotating: ", error

  ).group('apiOps')


  delayRefresh: task( ->
    yield waitIdleTime(4000)
    @get('refresh').perform()
  )

  refresh: task( ->
    return unless (acc = @get('account'))
    try
      yield @get('recovery').getExpiringUnspents(acc)
    catch error
      Logger.error "Error refresh: ", error
  )

  actions:
    refresh: ->
      @get('refresh').perform()

    rotateAll: (inputs) ->
      @get('rotateInputs').perform(inputs)


    confirmRotation: ->
      if (tx = @get('preparedTx'))
        @get('confirmRotation').perform(tx)

    cancelRotation: ->
      if (tx = @get('preparedTx'))
        @get('cancelRotation').perform(tx)

    clearDone: ->
      @set('doneTx', false)

)

export default NlockExpiring