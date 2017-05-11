`import Ember from 'ember'`

StreamEvt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  clock: Ember.inject.service('clock')

  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: Ember.computed.alias('entry.content')

  label: Ember.computed.alias('event.cmo.name')

  inFuture: ( ->
    @get('event.cmo.dateExecutable') > moment.now()
  ).property('event.cmo.dateExecutable', 'clock.minutes')

)


`export default StreamEvt`
