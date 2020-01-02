import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { scheduleOnce } from '@ember/runloop'

SCROLL_OPTIONS = {
    speed: 100                # Integer. How fast to complete the scroll in milliseconds
    easing: 'easeInOutCubic'  # Easing pattern to use
    offset: 0               # Integer. How far to offset the scrolling anchor location in pixels
    updateURL: false           # Boolean. If true, update the URL hash on scroll
}

LICENSE_PATH = 'licenses'

DisplayLicense = Component.extend(


  cm: service('cm-session')
  i18n: service()

  'modal-id': 'license'

  notAcceptable: true
  displayOnly: false


  offset: SCROLL_OPTIONS.offset

  setupScroll: (->
    scheduleOnce('afterRender', this, -> @set('scroll', new SmoothScroll('.scrollto', SCROLL_OPTIONS)))
  ).on('didInsertElement')


  licenseFile: ( ->
    language = @get('i18n.locale')
    "#{LICENSE_PATH}/#{language}"
  ).property('i18n.locale')

  tearoffScroll: ( -> @get('scroll')?.destroy()).on('willDestroyElement')


  actions:
    scrollDown: ->
      if el = document.querySelector('#btm')
        @get('scroll')?.animateScroll(el)

    enableAccept: ->
      @set 'notAcceptable', false

    disableAccept: ->
      @set 'notAcceptable', true
)

export default DisplayLicense
