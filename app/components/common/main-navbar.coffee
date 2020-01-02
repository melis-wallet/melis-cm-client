import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { scheduleOnce } from '@ember/runloop'
import $ from 'jquery'

import StyleBindings from 'ember-leaf-core/mixins/leaf-style-bindings'

MainNavbar = Component.extend(

  classNames: ['navbar', 'navbar-inverse']
  ariaRole: 'navigation'

  appState: service('app-state')

  menu_expanded: alias('appState.menuExpanded')


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
    scheduleOnce 'afterRender', this, @_toggleFixBar
  ).observes('appState.navbarFixed').on('willInsertElement')


  _toggleFixBar: ->
    if @get('appState.navbarFixed')
      $('body').addClass('main-navbar-fixed')
    else
      $('body').removeClass('main-navbar-fixed')


  closeCollapsible: (->
     scheduleOnce 'afterRender', this, @_closeCollapsible
  )

  _closeCollapsible:->
    # noop since the collapse is empty now
    #@.$('#main-navbar-collapse').collapse('hide')

)

export default MainNavbar
