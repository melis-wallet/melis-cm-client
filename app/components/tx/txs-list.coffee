`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

TxsList = Ember.Component.extend(

  cm:  Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')


  classNames: ['history-container']

  pageOps: taskGroup().drop()

  hideNext: false
  hidePrev: false

  filter: null

  txs: null
  selected: null

  account: null

  txsSorting: ['time:desc']
  txsSorted: Ember.computed.sort('txs', 'txsSorting')

  txsFiltered: (->
    filter = @get('filter')

    @get('txsSorted').filter( (tx)->
      if filter
        switch filter
          when 'in' then !Ember.get(tx, 'negative')
          when 'out' then Ember.get(tx, 'negative')
          when 'star' then Ember.get(tx, 'cmo.meta.starred')

      else
        true
    )
  ).property('txsSorted.[]', 'filter')


  prefetch: task((account) ->
    svc = @get('txsvc')
    if (account ?= @get('account'))
      if !account.get('txiFetchDone')
        try
          yield svc.txiFetch(account)
        catch error
          Ember.Logger.error 'Error prefetching: ', error
  ).group('pageOps')


  getMore: task((account) ->
    svc = @get('txsvc')
    if (account ?= @get('account'))
      try
        yield svc.txiFetchMore(account)
      catch error
        Ember.Logger.error 'Error prefetching: ', error
  )

  setup: (->
    @set('txs', Ember.A())
    svc = @get('txsvc')
    if (account = @get('account'))
      @set 'txs', svc.findByAcct(account)
      @get('prefetch').perform(account)

  ).observes('account').on('init')

  accountChanged: ( ->
    @set('selected', null)
  ).observes('account')


  actions:
    toggleStar: (tx) ->
      @sendAction('on-toggle-star', tx)

    toggleFilter: (value)->
      if @get('filter') == value
        @set('filter', null)
      else
        @set('filter', value)


    clearSelected: ->
      @set 'selected', null


    getMore: (account) ->
      @get('getMore').perform()

    selectTx: (tx) ->
      if @get('selected') == tx
        @sendAction('on-select-tx')
      else
        @sendAction('on-select-tx', tx)
)

`export default TxsList`

