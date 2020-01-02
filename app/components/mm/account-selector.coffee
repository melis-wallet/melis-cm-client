import Component from '@ember/component'
import { get, set, getProperties } from '@ember/object'
import { inject as service } from '@ember/service'
import { alias, filterBy, sort } from "@ember/object/computed"

AccountSelector = Component.extend(
  tagName: 'ul'
  classNames: ['navigation']

  cm: service('cm-session')
  coinsvc: service('cm-coin')
  routing: service('-routing')
  app_state: service('app-state')

  currentWallet: alias('cm.currentWallet')
  currentAccount: alias('cm.currentAccount')

  coins: alias('coinsvc.coins')
  coin: alias('app_state.store.coin')

  selectedCoin: ( ->
    if coin = @get('coin')
      @get('selectCoins').findBy('id', coin)
    else
      @get('selectCoins').findBy('symbol', 'nocoin')
  ).property('activeCoins', 'coin')

  selectCoins: ( ->
    [{id: null, label: 'allcoins', symbol: 'nocoin'}].concat(
      @get('activeCoins').map( (c) ->
        return(id: get(c, 'unit'), symbol: get(c, 'symbol'), label: get(c, 'label'))
      )
    )
  ).property('activeCoins')

  activeCoins: ( ->
    coins = @get('cm.visibleAccts').map((a) -> a.coin).uniq()
    @get('coins').filter((c) -> coins.includes(get(c, 'unit')))
  ).property('cm.visibleAccts.[]', 'coins.[]')

  filteredAccts: ( ->
    if coin = @get('coin')
      @get('cm.visibleAccts').filterBy('coin', coin)
    else
      @get('cm.visibleAccts')
  ).property('coin', 'cm.visibleAccts.[]')


  accountsSorting: ['pos:asc', 'cmo.cd:asc'],
  accounts: sort('filteredAccts', 'accountsSorting')

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
      @sendAction('on-filter-change')


    changeFilterCoin: (coin) ->
      console.error "CHANGEFILT", coin
      if @get('coin') != get(coin, 'id')
        @set('coin', get(coin, 'id'))
      else
        @set('coin', null)
      @sendAction('on-filter-change')

)

export default AccountSelector