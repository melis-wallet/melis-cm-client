import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

# this is kind of inelegant, but serves as a concept
EXPAND_ROUTES = [
  'enroll',
  'backup',
  'create-account',
  'pair-import',
  'import',
  'pair',
  'recover'
]

HeadingContainer = Component.extend(
  classNames: ['signin-container', 'animated', 'fadeIn']

  title: 'Melis'
  'logo-icon': 'fa fa-database bg-warning'

  cm: service('cm-session')
  routing:  service('-routing')

  ready: alias('cm.ready')

  expanded: ( ->
    try
      route = @get('routing.currentRouteName').split('.').pop()
      EXPAND_ROUTES.includes(route)
    catch
      false
  ).property('routing.currentRouteName')
)

export default HeadingContainer
