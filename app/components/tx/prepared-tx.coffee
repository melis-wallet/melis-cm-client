import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get, getWithDefault } from '@ember/object'

import { task } from 'ember-concurrency'

PreparedTx = Component.extend(

  cm: service('cm-session')
  ptxsvc: service('cm-ptxs')
  tx: null
  view: 'detailed'

  chatInput: false

  missingSigs: (->
    # TODO POC algo, not taking mandatory sigs into account
    sigs = @getWithDefault('tx.cmo.signatures.length', 0)

    return @get('tx.account.cmo.minSignatures') - sigs
  ).property('tx.cmo.signatures.[]')

  approveTx: task((tx) ->
    @set 'error', null
    try
      yield @get('ptxsvc').ptxSign(tx)
    catch error
      @set 'error', getWithDefault(error, 'msg', error)
  ).drop()

  cancelTx: task((tx) ->
    @set 'error', null
    try
      yield @get('ptxsvc').ptxCancel(tx)
    catch error
      @set 'error', getWithDefault(error, 'msg', error)
  ).drop()


  actions:
    toggleInput: ->
      @toggleProperty('chatInput')

    approveTx: ->
      if tx = @get('tx')
        @get('approveTx').perform(tx)

    cancelTx: ->
      if (tx = @get('tx')) && tx.get('accountIsOwner')
        @get('cancelTx').perform(tx)

)

export default PreparedTx
