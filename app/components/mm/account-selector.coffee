`import Ember from 'ember'`

AccountSelector = Ember.Component.extend(
  tagName: 'ul'
  classNames: ['navigation']

  cm: Ember.inject.service('cm-session')
  routing: Ember.inject.service('-routing')

  currentWallet: Ember.computed.alias('cm.currentWallet')
  currentAccount: Ember.computed.alias('cm.currentAccount')

  accountsSorting: ['cmo.cd:asc'],
  accounts: Ember.computed.sort('cm.visibleAccts', 'accountsSorting')

  hidecurrent: false

  app_state: Ember.inject.service('app-state')

  linkFollowed: ((event)->
    event.preventDefault()
    @get('app_state').routingStateChanged()
  ).on('click')

  name: (->
    @get('currentAccount.meta.name')
  ).property('currentAccount')

  accountRoute: (->
    @get('routing.currentRouteName').includes('account')
  ).property('routing.currentRouteName')

  # could be better, routes ending in 'detail' should go to the collection route
  targetRoute: (->
    route = @get('routing.currentRouteName')

    if route.includes('account')
      route.replace('.detail', '')
    else
      'main.account.summary'
  ).property('routing.currentRouteName')

  actions:
    selectAccount: (acc) ->
      cm = @get('cm')
      cm.selectAccount(acc.get('num'))

)

`export default AccountSelector`