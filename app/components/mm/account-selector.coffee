`import Ember from 'ember'`

AccountSelector = Ember.Component.extend(
  tagName: 'ul'
  classNames: ['navigation']

  cm: Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')
  routing: Ember.inject.service('-routing')
  app_state: Ember.inject.service('app-state')

  currentWallet: Ember.computed.alias('cm.currentWallet')
  currentAccount: Ember.computed.alias('cm.currentAccount')

  coins: Ember.computed.alias('coinsvc.coins')
  coin: Ember.computed.alias('app_state.store.coin')

  filteredAccts: ( ->
    if coin = @get('coin')
      @get('cm.visibleAccts').filterBy('coin', coin)
    else
      @get('cm.visibleAccts')
  ).property('coin', 'cm.visibleAccts.[]')


  accountsSorting: ['pos:asc', 'cmo.cd:asc'],
  accounts: Ember.computed.sort('filteredAccts', 'accountsSorting')

  hidecurrent: false

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
      cm.selectAccount(acc.get('pubId'))

    setFilter: (unit) ->
      if @get('coin') != unit
        @set('coin', unit)
      else
        @set('coin', null)

)

`export default AccountSelector`