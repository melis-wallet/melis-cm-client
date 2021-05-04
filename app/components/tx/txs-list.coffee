import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { sort } from '@ember/object/computed'
import { get, set } from '@ember/object'
import { A } from '@ember/array'

import CMCore from 'melis-api-js'

import { task, taskGroup } from 'ember-concurrency'
import FileSaverMixin from 'ember-cli-file-saver/mixins/file-saver'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C
EXPORT_PG_SIZE = 1000

TxsList = Component.extend(FileSaverMixin,

  cm: service('cm-session')
  txsvc: service('cm-tx-infos')


  classNames: ['history-container']

  pageOps: taskGroup().drop()

  hideNext: false
  hidePrev: false

  filter: null

  txs: null
  selected: null

  account: null

  txsSorting: ['time:desc']
  txsSorted: sort('txs', 'txsSorting')

  txsFiltered: (->
    filter = @get('filter')

    @get('txsSorted').filter( (tx)->
      if filter
        switch filter
          when 'in' then !get(tx, 'negative')
          when 'out' then get(tx, 'negative')
          when 'star' then get(tx, 'cmo.meta.starred')

      else
        true
    )
  ).property('txsSorted.[]', 'filter')


  doExport: task(->
    api = @get('cm.api')
    account = @get('account')
  
    data = []
    fetchMore = true
    page = 0

    while (fetchMore)

      res = yield api.txInfosGet(account.get('cmo'), {
          direction:  C.DIR_ASCENDING
        }, {
          page: page
          size: EXPORT_PG_SIZE
          sortField: C.FIELD_LAST_UPDATED
          sortDir: C.DIR_DESCENDING
        }
      )

      console.log('res: ', res)

      if (res && res.list)
        data.pushObjects(res.list.map((e) => 
          return (
            tx: e.tx,
            address: e.address,
            amount: e.amount,
            fees: e.fees,
            address: e.address,
            currencyData: e.meta.currencyData,
            info: e.meta.info,
            labels: e.labels )        
        ))
      
      if ( !res || !res.hasNext )
        fetchMore = false
      else
        page = page + 1

    @saveFileAs('transactions.json', JSON.stringify(data), 'application/json')
  ).drop()


  prefetch: task((account) ->
    svc = @get('txsvc')
    if (account ?= @get('account'))
      if !account.get('txiFetchDone')
        try
          yield svc.txiFetch(account)
        catch error
          Logger.error 'Error prefetching: ', error
  ).group('pageOps')


  getMore: task((account) ->
    svc = @get('txsvc')
    if (account ?= @get('account'))
      try
        yield svc.txiFetchMore(account)
      catch error
        Logger.error 'Error prefetching: ', error
  )

  setup: (->
    @set('txs', A())
    svc = @get('txsvc')
    if (account = @get('account'))
      @set 'txs', svc.findByAcct(account)
      @get('prefetch').perform(account)

  ).observes('account').on('init')

  accountChanged: ( ->
    @set('selected', null)
  ).observes('account')


  actions:
    downloadTxs: ->
      @doExport.perform()


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

export default TxsList

