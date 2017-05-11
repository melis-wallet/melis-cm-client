`import Ember from 'ember'`
`import ScrollHandler from '../../mixins/scroll-handler'`
`import ResizeAware from 'ember-resize/mixins/resize-aware'`

SCROLL_OPTIONS = {
    speed: 500                # Integer. How fast to complete the scroll in milliseconds
    easing: 'easeInOutCubic'  # Easing pattern to use
    offset: 100               # Integer. How far to offset the scrolling anchor location in pixels
    updateURL: true           # Boolean. If true, update the URL hash on scroll
}


DashboardBox = Ember.Component.extend(ScrollHandler, ResizeAware,

  cm: Ember.inject.service('cm-session')
  svc: Ember.inject.service('cm-stream')
  wallet: Ember.inject.service('cm-wallet')
  media: Ember.inject.service('responsive-media')

  inited: Ember.computed.alias('svc.inited')
  streamEntries: Ember.computed.alias('wallet.stream.current')
  newEntries: Ember.computed.alias('wallet.stream.newer')

  scrollTimeout: 10

  displayed: ( ->
    !Ember.isEmpty(@get('newEntries'))
  ).property('streamEntries', 'newEntries')

  debouncedDidResize: ->
    if @get('affix')
      @.$('.affix-panel').css(width: @.$().width())

  didScroll: (rect) ->
    if @get('media.isMobile')
      @setProperties(affix: false, _fixTop: null)
    else
      scrollTop  = Ember.$(document).scrollTop()

      if scrollTop <= @get('_fixTop') && @get('affix')
        @setProperties(affix: false, _fixTop: null)
        @.$('.affix-panel').css(top: '', width: '')

      else if (rect.top < SCROLL_OPTIONS.offset) && !@get('affix')
        @setProperties(affix: true, _fixTop: scrollTop)
        @.$('.affix-panel').css(top: SCROLL_OPTIONS.offset + 'px', width: @.$().width())


  setupScroll: (->
    Ember.run.scheduleOnce('afterRender', this, ->
      smoothScroll.init(SCROLL_OPTIONS)
    )
  ).on('didInsertElement')

  tearoffScroll: ( ->
    smoothScroll.destroy()
  ).on('willDestroyElement')



  actions:
    scrollTo: (entry) ->
      smoothScroll.animateScroll('#' + entry.id)

    resetScroll: ->
      smoothScroll.animateScroll(0)

    showNewer: ->
      { wallet, svc } = @getProperties('wallet', 'svc')
      svc.setLowWater(wallet, @get('entry.updated'))
      svc.setHighWater(wallet, moment.now())





)

`export default DashboardBox`
