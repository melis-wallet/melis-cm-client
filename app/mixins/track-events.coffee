import Mixin from '@ember/object/mixin'
import { A } from '@ember/array'

TrackEvents = Mixin.create

  _events: null

  teardownListeners: ( ->
    api = @get('cm.api')
    @get('_events').forEach((e) -> api.removeListener(e.event, e.method))
  ).on('willDestroyElement')

  trackEvent: (event, method) ->
    e = {
      event: event
      method: method
    }
    @set('_events',  A()) if !@get('_events')
    @get('cm.api').on(e.event, e.method)
    @get('_events').pushObject(e)


export default TrackEvents
