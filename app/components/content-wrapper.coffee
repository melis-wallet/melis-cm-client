`import Ember from 'ember'`
`import RecognizerMixin from 'ember-gestures/mixins/recognizers'`


ContentWrapper = Ember.Component.extend(RecognizerMixin,

  cm: Ember.inject.service('cm-session')
  appState: Ember.inject.service('app-state')

  expanded: Ember.computed.alias('appState.menuExpanded')

  recognizers: 'swipe'

  swipeRight: ->
    @set('expanded', true)

  swipeLeft: ->

    @set('expanded', false)
)

`export default ContentWrapper`


