import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import $ from 'jquery'

import ScrollHandler from '../../mixins/scroll-handler'
import ResizeAware from 'ember-resize/mixins/resize-aware'


UrgentStreamBox = Component.extend(ScrollHandler, ResizeAware,

  cm: service('cm-session')
  svc: service('cm-stream')
  media: service('responsive-media')

  inited: alias('svc.inited')
  streamEntries: alias('account.stream.urgentCurrent')
  newEntries: alias('account.stream.urgentNewer')

  affix: false
  scrollTimeout: 10

  account: null

  scroller: null
  scrollOffset: alias('scroller.offset')

  displayed: ( ->
    !isEmpty(@get('streamEntries')) || !isEmpty(@get('newEntries'))
  ).property('streamEntries', 'newEntries')

  displayTicker: ( ->
    !@get('media.isMobile') || !@get('displayed')
  ).property('displayed', 'media.isMobile')

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

      else if (rect.top <  @get('scrollOffset')) && !@get('affix')
        @setProperties(affix: true, _fixTop: scrollTop)
        @.$('.affix-panel').css(top: @get('scrollOffset') + 'px', width: @.$().width())


  accountChanged: (->
    @get('scroll')?.animateScroll(0)
  ).observes('account')

  actions:
    moveTo: (entry) ->
      @sendAction('onmoveto', entry)

    resetPosition: ->
      @sendAction('onresetposition')

    showNewer: ->
      account = @get('account')
      @get('svc').setLowWater(account, @get('entry.updated'), account)
      @get('svc').setHighWater(account, moment.now(), account)
)

export default UrgentStreamBox
