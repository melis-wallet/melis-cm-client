`import Ember from 'ember'`
`import InViewportMixin from 'ember-in-viewport'`

ScrollerGuard = Ember.Component.extend(InViewportMixin,

  didEnterViewport: ->
    @sendAction('on-enter')

  didExitViewport: ->
    @sendAction('on-exit')


  setup: ( ->
    @set 'viewportSpy', true
  ).on('didInsertElement')

)


`export default ScrollerGuard`