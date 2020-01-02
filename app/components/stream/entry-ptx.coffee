import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, getWithDefault } from '@ember/object'

import StreamEntry from './stream-entry'
import InViewportMixin from 'ember-in-viewport'
import { task, taskGroup } from 'ember-concurrency'

StreamPtx = StreamEntry.extend(InViewportMixin,

  ptxsvc: service('cm-ptxs')
  i18n: service()

  classNames: ['stream-entry', 'row', 'animated', 'zoomIn', 'quick']
  #classNameBindings: [ 'viewportEntered:zoomIn' ]

  entry: null
  error: null

  tx: alias('entry.content')

  isRespent:  alias('tx.isRespent')

  missingSigs: (->
    # TODO POC algo, not taking mandatory sigs into account
    sigs = @getWithDefault('tx.cmo.signatures.length', 0)

    return @get('tx.account.cmo.minSignatures') - sigs
  ).property('tx.cmo.signatures.[]')


  apiOps: taskGroup().drop()

  approveTx: task((tx) ->
    @set 'error', null
    try
      yield @get('ptxsvc').ptxSign(tx)
    catch error
      @set 'error', @get('i18n').t_ex(error)
  ).group('apiOps')

  cancelTx: task((tx) ->
    @set 'error', null
    try
      yield @get('ptxsvc').ptxCancel(tx)
    catch error
      @set 'error', getWithDefault(error, 'msg', error)
  ).group('apiOps')


  reissueTx: task((tx) ->
    @set 'error', null
    try
      yield @get('ptxsvc').ptxReissue(tx)
    catch error
      @set 'error', getWithDefault(error, 'msg', error)
  ).group('apiOps')

  actions:
    reissueTx: ->
      if tx = @get('tx')
        @get('reissueTx').perform(tx)

    approveTx: ->
      if tx = @get('tx')
        @get('approveTx').perform(tx)

    cancelTx: ->
      if (tx = @get('tx')) && tx.get('accountIsOwner')
        @get('cancelTx').perform(tx)
)

export default StreamPtx
