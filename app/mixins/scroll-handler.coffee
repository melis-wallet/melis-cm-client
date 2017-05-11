`import Ember from 'ember'`


ScrollHandler = Ember.Mixin.create(

  scrollTimeout:      100
  boundingClientRect: 0
  windowHeight:       0
  windowWidth:        0

  _updateBoundingClientRect: ->
    el = @.$()[0]
    boundingClientRect = el.getBoundingClientRect()
    @set('boundingClientRect', boundingClientRect)
    @trigger('didScroll', boundingClientRect)

  _setup: ( ->
    Ember.run.scheduleOnce('afterRender', this, ->
      @_updateBoundingClientRect()
      @set('windowHeight', window.innerHeight || document.documentElement.clientHeight)
      @set('windowWidth', window.innerWidth || document.documentElement.clientWidth)
    )
  ).on('didInsertElement')

  _scrollHandler: ->
    Ember.run.debounce(this, '_updateBoundingClientRect', this.get('scrollTimeout'))

  _bindScroll: (->
    scrollHandler = @_scrollHandler.bind(this)
    Ember.$(document).on('touchmove.scrollable', scrollHandler)
    Ember.$(window).on('scroll.scrollable', scrollHandler)
  ).on('didInsertElement')


  _unbinScroll: (->
    Ember.$(window).off('.scrollable')
    Ember.$(document).off('.scrollable')
  ).on('willDestroyElement')

)

`export default ScrollHandler`