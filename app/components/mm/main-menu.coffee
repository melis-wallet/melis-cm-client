`import Ember from 'ember'`
`import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'`
`import RecognizerMixin from 'ember-gestures/mixins/recognizers'`


MainMenu = Ember.Component.extend(SlyEnabled, RecognizerMixin,

  classNames: ['side-menu']
  ariaRole: 'navigation'

  recognizers: 'swipe'

  appState: Ember.inject.service('app-state')

  expanded: Ember.computed.alias('appState.menuExpanded')

  # this needed by a quick fix for an issue with the MM getting confused about scrolling
  # a better way would go through signalling to app-state
  cm: Ember.inject.service('cm-session')

  # tell sly to fill the container space
  'fill-container': true

  #
  #
  #
  fixMenu: (->
    @get('cm.accounts.length')
    Ember.run.schedule('afterRender', this, ->
      if @get('appState.menuFixed')
        Ember.$('body').addClass('main-menu-fixed')
      else
        Ember.$('body').removeClass('main-menu-fixed')
    )
  ).observes('appState.menuFixed').on('didInsertElement')


  # see below
  # this needed by a quick fix for an issue with the MM getting confused about scrolling
  # a better way would go through signalling to app-state
  contentChanged: ( ->
    Ember.Logger.debug('[mm] content changed')
    @slyContentChanged()
  ).observes('cm.accounts.length')

  #
  #
  #
  toggleExpand: (->
    Ember.run.schedule('afterRender', this, ->
      if @get('expanded')
         Ember.$('body').addClass('mme').removeClass('mmc')
      else
         Ember.$('body').addClass('mmc').removeClass('mme')
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

`export default MainMenu`
