import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, filterBy, mapBy, sum } from '@ember/object/computed'
import { task, taskGroup } from 'ember-concurrency'
import { A } from '@ember/array'
import { get, set, setProperties } from '@ember/object'
import { isPresent, isEmpty } from '@ember/utils'

import groupBy from '../../utils/group-by'
import TreeNode from '../../utils/treenode'
import CMCore from 'npm:melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'


C = CMCore.C

AdvancedSrcs = Component.extend(

  cm: service('cm-session')
  txsvc: service('cm-tx-infos')


  account: null
  txo: null

  hasNext: false

  ops: taskGroup().drop()

  groupedTxo: ( ->
    groups = A()
    items = @get('txo')
    return if isEmpty(items)

    items.forEach((item) ->
      value = get(item, 'aa')
      group = groups.find((item) -> get(item, 'value.address') == get(value, 'address'))

      if isPresent(group)
        amount = get(group, 'amount') + get(item, 'amount')
        firstcd = get(group, 'firstcd')
        itemcd = get(item, 'cd')
        firstcd = itemcd if (itemcd < firstcd)
        setProperties(group,
          amount: amount
          firstcd: firstcd
        )
        get(group, 'items').push(item)
      else
        group = { amount: get(item, 'amount'), firstcd: get(item, 'cd'), value: value, items: [item] }
        groups.push(group)

    )
    return groups
  ).property('txo.@each.aa')


  selectedTxo: filterBy('txo', 'selected', true)
  selectedAmounts: mapBy('selectedTxo', 'amount')
  selectedTotal: sum('selectedAmounts')


  selectionChanged: (->
    @sendAction('on-change', @get('selectedTotal'), @get('selectedTxo'))
  ).observes('selectedTotal')


  fetchTxo: task(->
    return unless (account = @get('account'))

    try
      res = yield @get('cm.api').getUnspents(account.get('cmo'), sortField: 'creationDate', sortDir: C.DIR_DESCENDING)
      if list = get(res, 'list')
        @set('txo', list)
        @set('hasNext', get(res, 'hasNext'))
    catch error
      Logger.error(error)
  )



  setup: ( ->
    @get('fetchTxo').perform()
    @get('selectedTotal')
  ).on('init').observes('account')


  actions:
    toggleExpanded: (addr) ->
      set(addr, 'expanded', !get(addr, 'expanded'))

    selectTxo: (selected, txo, addr) ->
      set(txo, 'selected', !selected)
      set(addr, 'selected', get(addr, 'items')?.isEvery('selected', true))

    selectAddr: (addr) ->
      s = get(addr, 'selected')
      set(addr, 'selected', !s)
      get(addr, 'items')?.forEach((i) -> set(i, 'selected', !s))
)

export default AdvancedSrcs
