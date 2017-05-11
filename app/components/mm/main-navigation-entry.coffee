`import Ember from 'ember'`
`import ActiveLinkMixin from 'ember-cli-active-link-wrapper/mixins/active-link'`

MainMenuEntryComponent = Ember.Component.extend(
  #ActiveLinkMixin,

  router: Ember.inject.service('-routing')

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

  app_state: Ember.inject.service('app-state')


  # active-link-mixin produces nasty backtracking rerenders,
  # this is an ugly patch
  #
  trackLink: ( ->

    Ember.run.scheduleOnce('afterRender', this, (->
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

`export default MainMenuEntryComponent`

