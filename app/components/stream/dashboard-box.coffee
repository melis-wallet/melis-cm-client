import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import { scheduleOnce } from '@ember/runloop'
import $ from 'jquery'

import ScrollHandler from '../../mixins/scroll-handler'
import ResizeAware from 'ember-resize/mixins/resize-aware'


DashboardBox = Component.extend(ScrollHandler, ResizeAware,

  cm: service('cm-session')
  svc: service('cm-stream')
  wallet: service('cm-wallet')
  media: service('responsive-media')

  inited: alias('svc.inited')
  streamEntries: alias('wallet.stream.current')
  newEntries: alias('wallet.stream.newer')

  scrollTimeout: 10

  scroller: null
  scrollOffset: alias('scroller.offset')

  displayed: ( ->
    !isEmpty(@get('newEntries'))
  ).property('streamEntries', 'newEntries')

  debouncedDidResize: ->
    if @get('affix')
      @.$('.affix-panel').css(width: @.$().width())

  didScroll: (rect) ->
    if @get('media.isMobile')
      @setProperties(affix: false, _fixTop: null)
    else
      scrollTop  = $(document).scrollTop()

      if scrollTop <= @get('_fixTop') && @get('affix')
        @setProperties(affix: false, _fixTop: null)
        @.$('.affix-panel').css(top: '', width: '')

      else if (rect.top < @get('scrollOffset')) && !@get('affix')
        @setProperties(affix: true, _fixTop: scrollTop)
        @.$('.affix-panel').css(top: @get('scrollOffset') + 'px', width: @.$().width())


  actions:
    moveTo: (entry) ->
      @sendAction('onmoveto', entry)

    resetPosition: ->
      @sendAction('onresetposition')

    showNewer: ->
      { wallet, svc } = @getProperties('wallet', 'svc')
      svc.setLowWater(wallet, @get('entry.updated'))
      svc.setHighWater(wallet, moment.now())

)

export default DashboardBox
