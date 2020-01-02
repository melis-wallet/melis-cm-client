import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, getWithDefault, computed } from '@ember/object'
import { isBlank } from '@ember/utils'

import { task, taskGroup } from 'ember-concurrency'
import { mergedProperty } from 'melis-cm-svcs/utils/misc'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'

import Logger from 'melis-cm-svcs/utils/logger'


CUTOFF_FEEBUMP = 2

StreamTx = Component.extend(

  cm: service('cm-session')
  ptxsvc: service('cm-ptxs')
  entry: null

  classNames: ['stream-entry', 'row','animated', 'fadeIn', 'xquick']

  tx: alias('entry.content')

  showControls: false

  feesMult: 1
  oldMult: alias('linkedPtx.cmo.meta.feeMultiplier')

  clickable: computed.not('showControls')

  invalidated: alias('tx.cmo.invalidated')

  linkedPtx: null
  replacingPtx: null

  canBump: ( ->
    !@get('invalidated') && @get('tx.cmo.optInRbf') && @get('tx.unconfirmed') && @get('tx.negative')
  ).property('invalidated', 'tx.cmo.optInRbf', 'tx.unconfirmed', 'tx.negative')

  showBump: (->
    @get('canBump') && @get('linkedPtx') && (@get('oldMult') < CUTOFF_FEEBUMP)
  ).property('canBump', 'linkedPtx')

  apiOps: taskGroup().drop()

  fetchOriginalTrig: ( ->
    if @get('showControls') && @get('canBump') && !@get('linkedPtx') && (hash = @get('tx.cmo.tx'))
      @get('fetchOriginal').perform(hash, @get('tx.account'))
  ).observes('showControls')


  fetchOriginal: task((hash, account) ->
    try
      # wait for the expand to be completed
      yield waitIdle()
      res = yield @get('ptxsvc').getPtxByHash(hash, account)
      @set 'linkedPtx', res
    catch error
      Logger.error "Error: ",  error
  ).group('apiOps')

  changeTxLabels: task( (labels, tx) ->
    api = @get('cm.api')
    try
      res = yield api.txInfoSet(get(tx, 'cmo.id'), labels, get(tx, 'cmo.meta'))
      @set 'selected', res
    catch error
      Logger.error "Error: ",  error
  ).group('apiOps')


  changeTxInfo: task( (value, tx) ->
    if !isBlank(tx)
      api = @get('cm.api')
      meta = mergedProperty(tx, 'cmo.meta', info: value)
      try
        res = yield api.txInfoSet(get(tx, 'cmo.id'), get(tx, 'cmo.labels'), meta)
        @set 'selected', res
      catch error
        Logger.error "Error: ",  error
  ).group('apiOps')


  requestRbf: task( (tx) ->
    hash = get(tx, 'cmo.tx')
    api = @get('cm.api')

    try
      if (ptxId = @get('linkedPtx.cmo.originalPtx'))
        res = yield @get('ptxsvc').ptxFeeBumpById(tx.get('account'), ptxId, @get('feesMult'))
      else if (ptx = @get('linkedPtx'))
        res = yield @get('ptxsvc').ptxFeeBump(ptx, @get('feesMult'))
      else
        res = yield @get('ptxsvc').txFeeBump(tx.get('account'), hash, @get('feesMult'))
      @set('replacingPtx', res)
    catch error
      Logger.error "Error: ",  error
  )


  actions:
    requestRbf: ->
      if(tx = @get('tx'))
          @get('requestRbf').perform(tx)

    toggleControls: ->
      @toggleProperty('showControls')

    showControls: ->
      if @get('clickable')
        @set('showControls', true)

    hideControls: ->
      @set('showControls', false)

    changeTxLabels: (labels) ->
      if(tx = @get('tx'))
        @get('changeTxLabels').perform(labels, tx)


    changeTxInfo: (value) ->
      if(tx = @get('tx'))
        @get('changeTxInfo').perform(value, tx)

)


export default StreamTx
