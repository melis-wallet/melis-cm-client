import Component from '@ember/component'
import { inject as service } from '@ember/service'

AdvancedPtx = Component.extend(

  cm: service('cm-session')

  account: null
  preparedTx: null

  actions:
    cancelTx: ->
      @sendAction('on-cancel')

    proposeTx: ->
      @sendAction('on-propose')

    confirmTx: ->
      @sendAction('on-confirm')
)


export default AdvancedPtx
