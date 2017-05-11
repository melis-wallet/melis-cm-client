`import Ember from 'ember'`
`import RecognizerMixin from 'ember-gestures/mixins/recognizers'`


ContentWrapper = Ember.Component.extend(RecognizerMixin,

  cm: Ember.inject.service('cm-session')
  appState: Ember.inject.service('app-state')

  expanded: Ember.computed.alias('appState.menuExpanded')

  recognizers: 'swipe'





  swipeRight: ->
    console.error "swipe"
    @set('expanded', true)

  swipeLeft: ->
    console.error "swipe"

    @set('expanded', false)
)

`export default ContentWrapper`


