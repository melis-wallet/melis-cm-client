`import Ember from 'ember'`
`import InViewportMixin from 'ember-in-viewport'`

StreamEntry = Ember.Component.extend(InViewportMixin,

  cm: Ember.inject.service('cm-session')
  entry: null


)


`export default StreamEntry`
