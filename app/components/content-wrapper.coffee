import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import RecognizerMixin from 'ember-gestures/mixins/recognizers'


ContentWrapper = Component.extend(RecognizerMixin,

  cm: service('cm-session')
  appState: service('app-state')

  expanded: alias('appState.menuExpanded')

  recognizers: 'swipe'

  swipeRight: ->
    @set('expanded', true)

  swipeLeft: ->

    @set('expanded', false)
)

export default ContentWrapper


