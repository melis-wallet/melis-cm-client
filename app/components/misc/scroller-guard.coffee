import Component from '@ember/component'
import InViewportMixin from 'ember-in-viewport'

ScrollerGuard = Component.extend(InViewportMixin,

  didEnterViewport: ->
    @sendAction('on-enter')

  didExitViewport: ->
    @sendAction('on-exit')


  setup: ( ->
    @set 'viewportSpy', true
  ).on('didInsertElement')
)

export default ScrollerGuard