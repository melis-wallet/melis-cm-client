`import Ember from 'ember'`

StreamEvt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: Ember.computed.alias('entry.content')

  label: ( ->
    @get('event.cmo.name') || @get('event.cmo.id')
  ).property('event.cmo.name', 'event.cmo.id')

  shouldShow: Ember.computed.notEmpty('event.cmo.lastUsedInLogin')

)


`export default StreamEvt`
