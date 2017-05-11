`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C
StreamTxm = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row','animated', 'fadeIn', 'quick']

  msg: Ember.computed.alias('entry.content')
  ptx: Ember.computed.alias('entry.ptx')

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


`export default StreamTxm`
