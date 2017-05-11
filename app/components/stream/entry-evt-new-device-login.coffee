`import Ember from 'ember'`

StreamEvt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: Ember.computed.alias('entry.content')

  label: ( ->
    @get('event.cmo.name') || @get('event.cmo.deviceId')
  ).property('event.cmo.name', 'event.cmo.deviceId')

)


`export default StreamEvt`
