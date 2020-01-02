import Component from '@ember/component'
import { scheduleOnce } from '@ember/runloop'

SCROLL_OPTIONS = {
    speed: 500                # Integer. How fast to complete the scroll in milliseconds
    easing: 'easeInOutCubic'  # Easing pattern to use
    offset: 100               # Integer. How far to offset the scrolling anchor location in pixels
    updateURL: true           # Boolean. If true, update the URL hash on scroll
}

SmoothScroller = Component.extend(

  offset: SCROLL_OPTIONS.offset

  setupScroll: (->
    scheduleOnce('afterRender', this, -> @set('scroll', new SmoothScroll('.stream-entry', SCROLL_OPTIONS)))
  ).on('didInsertElement')

  tearoffScroll: ( -> @get('scroll')?.destroy()).on('willDestroyElement')

  actions:
    scrollTo: (entry) ->
      if el = document.querySelector('#' + entry.id)
        @get('scroll')?.animateScroll(el)

    resetScroll: ->
      @get('scroll')?.animateScroll(0)

)

export default SmoothScroller