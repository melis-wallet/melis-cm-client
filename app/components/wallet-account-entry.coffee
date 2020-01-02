import Component from '@ember/component'
import { inject as service } from '@ember/service'


WalletAccountEntry = Component.extend(
  ariaRole: 'menuitem'

  cm: service('cm-session')
  routing: service('-routing')

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

export default WalletAccountEntry