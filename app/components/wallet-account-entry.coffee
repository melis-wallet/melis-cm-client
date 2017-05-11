`import Ember from 'ember'`

WalletAccountEntry = Ember.Component.extend(
  ariaRole: 'menuitem'

  cm: Ember.inject.service('cm-session')
  routing: Ember.inject.service('-routing')

  classNames: ['entry']

  content: null
  current: null

  active: ( ->
    @get('content') == @get('current')
  ).property('content', 'current')


  # could be better, routes ending in 'detail' should go to the collection route
  targetRoute: (->
    route = @get('routing.currentRouteName')

    if route.includes('account')
      route.replace('.detail', '')
    else
      'main.account.summary'
  ).property('routing.currentRouteName')
)

`export default WalletAccountEntry`