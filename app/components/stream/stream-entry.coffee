import Component from '@ember/component'
import { inject as service } from '@ember/service'
import InViewportMixin from 'ember-in-viewport'

StreamEntry = Component.extend(InViewportMixin,

  cm: service('cm-session')
  entry: null
)

export default StreamEntry
