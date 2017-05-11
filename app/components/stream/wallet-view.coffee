`import Ember from 'ember'`

WalletStreamView = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  svc: Ember.inject.service('cm-stream')
  walletsvc: Ember.inject.service('cm-wallet')

  inited: Ember.computed.alias('svc.inited')
  streamEntries: Ember.computed.alias('walletsvc.stream.current')

  classNames: ['stream']

  actions:
    goto: (id) ->
      # FIXME FIXME TODO this should be moved in from urgent box
      smoothScroll.animateScroll(id)

)

`export default WalletStreamView`
