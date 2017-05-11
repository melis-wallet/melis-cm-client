`import Ember from 'ember'`

MainStreamView = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  svc: Ember.inject.service('cm-stream')

  inited: Ember.computed.alias('svc.inited')
  streamEntries: Ember.computed.alias('account.stream.current')

  account: null

  classNames: ['stream']

  actions:
    goto: (id) ->
      # FIXME FIXME TODO this should be moved in from urgent box
      smoothScroll.animateScroll(id)

)

`export default MainStreamView`
