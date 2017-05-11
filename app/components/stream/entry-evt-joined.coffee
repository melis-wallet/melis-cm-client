`import Ember from 'ember'`

StreamEvt = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: Ember.computed.alias('entry.content')

  name: Ember.computed.alias('event.account.cmo.meta.name')
  code: Ember.computed.alias('event.cmo.activationCode')

)


`export default StreamEvt`
