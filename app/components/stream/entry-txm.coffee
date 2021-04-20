import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import CMCore from 'melis-api-js'

C = CMCore.C


StreamTxm = Component.extend(

  cm: service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row','animated', 'fadeIn', 'quick']

  msg: alias('entry.content')
  ptx: alias('entry.ptx')

  isSignature: ( ->
    @get('msg.type') == C.CHAT_MSG_TYPE_SIG
  ).property('msg.type')

  isMessage: ( ->
    @get('msg.type') == C.CHAT_MSG_TYPE_MSG
  ).property('msg.type')

  enoughSigners: ( ->
    @get('msg.payload.enoughSigners')
  ).property('msg.payload')

  ptxAnchor: ( ->
    '#ptx-' + @get('ptx.id')
  ).property('ptx.id')

  actions:
    goto: (id) ->
      @sendAction('on-goto', id)

)

export default StreamTxm
