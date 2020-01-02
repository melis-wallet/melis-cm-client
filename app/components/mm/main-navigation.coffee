import Component from '@ember/component'

MainNavigation = Component.extend(

  tagName: 'ul'
  classNames: ['navigation']
  ariaRole: 'navigation'

  expandedMenu: false

  content: []

  filteredItems: (->
    @get('content')
  ).property('content.[]')

)

export default MainNavigation
