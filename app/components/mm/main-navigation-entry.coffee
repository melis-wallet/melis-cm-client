import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { scheduleOnce } from '@ember/runloop'

import ActiveLinkMixin from 'ember-cli-active-link-wrapper/mixins/active-link'

MainMenuEntryComponent = Component.extend(
  #ActiveLinkMixin,

  router: service('-routing')
  app_state: service('app-state')


  tagName: 'li'
  ariaRole: 'menu-item'
  #classNameBindings: ['active', 'linkActive:active']
  classNameBindings: ['active']

  active: false

  content: null

  label: 'Menu Entry'

  icon: 'fa fa-code'

  notices: []

  'link-to': null


  # active-link-mixin produces nasty backtracking rerenders,
  # this is an ugly patch
  #
  trackLink: ( ->

    scheduleOnce('afterRender', this, (->
      if @$('a.ember-view')?.hasClass('active') then @$()?.addClass('active') else @$()?.removeClass('active')
    ))
  ).observes('router.currentRouteName').on('didInsertElement')
  setup: (-> @get('router.currentRouteName')).on('init')


  linkFollowed: ((event)->
    event.preventDefault()
    @get('app_state').routingStateChanged()
  ).on('click')

  actions:
    select: ->
      @get('app_state').routingStateChanged()
      @sendAction('action', @)

)

export default MainMenuEntryComponent

