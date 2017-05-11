`import Ember from 'ember'`
`import StyleBindings from 'ember-leaf-core/mixins/leaf-style-bindings'`

MainNavbar = Ember.Component.extend(

  classNames: ['navbar', 'navbar-inverse']
  ariaRole: 'navigation'

  appState: Ember.inject.service('app-state')

  menu_expanded: Ember.computed.alias('appState.menuExpanded')


  logo: 'Leaf'
  'logo-icon': 'fa fa-leaf bg-success'
  'logo-img': null
  'logo-link': 'index'


  actions:
    toggleMenu: ->
      if @get('menu_expanded')
        @set('menu_expanded', false)
      else
        @closeCollapsible()
        @set('menu_expanded', true)


  toggleFixBar: (->
    Ember.run.scheduleOnce 'afterRender', this, @_toggleFixBar
  ).observes('appState.navbarFixed').on('willInsertElement')


  _toggleFixBar: ->
    if @get('appState.navbarFixed')
      Ember.$('body').addClass('main-navbar-fixed')
    else
      Ember.$('body').removeClass('main-navbar-fixed')


  closeCollapsible: (->
     Ember.run.scheduleOnce 'afterRender', this, @_closeCollapsible
  )

  _closeCollapsible:->
    @.$('#main-navbar-collapse').collapse('hide')

)

`export default MainNavbar`
