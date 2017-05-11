`import Ember from 'ember'`

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

HeadingContainer = Ember.Component.extend(
  classNames: ['signin-container', 'animated', 'fadeIn']

  title: 'Melis'
  'logo-icon': 'fa fa-bitcoin bg-warning'

  cm: Ember.inject.service('cm-session')
  routing:  Ember.inject.service('-routing')

  ready: Ember.computed.alias('cm.ready')

  expanded: ( ->
    try
      route = @get('routing.currentRouteName').split('.').pop()
      EXPAND_ROUTES.includes(route)
    catch
      false
  ).property('routing.currentRouteName')

)

`export default HeadingContainer`
