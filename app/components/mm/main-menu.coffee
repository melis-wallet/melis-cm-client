import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { schedule, later } from '@ember/runloop'
import $ from 'jquery'

import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'
import RecognizerMixin from 'ember-gestures/mixins/recognizers'

import Logger from 'melis-cm-svcs/utils/logger'

MainMenu = Component.extend(SlyEnabled, RecognizerMixin,

  classNames: ['side-menu']
  ariaRole: 'navigation'

  recognizers: 'swipe'

  appState: service('app-state')

  expanded: alias('appState.menuExpanded')

  # this needed by a quick fix for an issue with the MM getting confused about scrolling
  # a better way would go through signalling to app-state
  cm: service('cm-session')

  # tell sly to fill the container space
  'fill-container': true

  #
  #
  #
  fixMenu: (->
    @get('cm.accounts.length')
    schedule('afterRender', this, ->
      if @get('appState.menuFixed')
        $('body').addClass('main-menu-fixed')
      else
        $('body').removeClass('main-menu-fixed')
    )
    later(this, (->  @slyContentChanged()), 1000)
  ).observes('appState.menuFixed').on('didInsertElement')


  # see below
  # this needed by a quick fix for an issue with the MM getting confused about scrolling
  # a better way would go through signalling to app-state
  contentChanged: ( ->
    Logger.debug('[mm] content changed')
    @slyContentChanged()
  ).observes('cm.accounts.length')

  #
  #
  #
  toggleExpand: (->
    schedule('afterRender', this, ->
      if @get('expanded')
         $('body').addClass('mme').removeClass('mmc')
      else
         $('body').addClass('mmc').removeClass('mme')
    )
  ).observes('expanded').on('didInsertElement')

  swipeRight: ->
    @set('expanded', true)

  swipeLeft: ->
    @set('expanded', false)


  actions:
    logout: ->
      @get('cm').resetApp()
)

export default MainMenu
