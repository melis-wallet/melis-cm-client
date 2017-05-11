`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`
`import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'`

CUTOFF_FEEBUMP = 2

StreamTx = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  ptxsvc: Ember.inject.service('cm-ptxs')
  entry: null

  classNames: ['stream-entry', 'row','animated', 'fadeIn', 'xquick']

  tx: Ember.computed.alias('entry.content')

  showControls: false

  feesMult: 1
  oldMult: Ember.computed.alias('linkedPtx.cmo.meta.feeMultiplier')

  clickable: Ember.computed.not('showControls')

  invalidated: Ember.computed.alias('tx.cmo.invalidated')

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
      Ember.Logger.error "Error: ",  error
  ).group('apiOps')

  changeTxLabels: task( (labels, tx) ->
    api = @get('cm.api')
    try
      res = yield api.txInfoSet(Ember.get(tx, 'cmo.id'), labels, Ember.get(tx, 'cmo.meta'))
      @set 'selected', res
    catch error
      Ember.Logger.error "Error: ",  error
  ).group('apiOps')


  changeTxInfo: task( (value, tx) ->
    if !Ember.isBlank(tx)
      api = @get('cm.api')
      meta = mergedProperty(tx, 'cmo.meta', info: value)
      try
        res = yield api.txInfoSet(Ember.get(tx, 'cmo.id'), Ember.get(tx, 'cmo.labels'), meta)
        @set 'selected', res
      catch error
        Ember.Logger.error "Error: ",  error
  ).group('apiOps')


  requestRbf: task( (tx) ->
    hash = Ember.get(tx, 'cmo.tx')
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
      Ember.Logger.error "Error: ",  error
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


`export default StreamTx`
