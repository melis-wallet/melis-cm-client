import Mixin from '@ember/object/mixin'
import { scheduleOnce, debounce } from '@ember/runloop'
import $ from 'jquery'

ScrollHandler = Mixin.create(

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
    scheduleOnce('afterRender', this, ->
      @_updateBoundingClientRect()
      @set('windowHeight', window.innerHeight || document.documentElement.clientHeight)
      @set('windowWidth', window.innerWidth || document.documentElement.clientWidth)
    )
  ).on('didInsertElement')

  _scrollHandler: ->
    debounce(this, '_updateBoundingClientRect', this.get('scrollTimeout'))

  _bindScroll: (->
    scrollHandler = @_scrollHandler.bind(this)
    $(document).on('touchmove.scrollable', scrollHandler)
    $(window).on('scroll.scrollable', scrollHandler)
  ).on('didInsertElement')


  _unbinScroll: (->
    $(window).off('.scrollable')
    $(document).off('.scrollable')
  ).on('willDestroyElement')
)

export default ScrollHandler