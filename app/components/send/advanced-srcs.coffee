`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import groupBy from '../../utils/group-by'`
`import TreeNode from '../../utils/treenode'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C

AdvancedSrcs = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  txsvc: Ember.inject.service('cm-tx-infos')


  account: null
  txo: null

  hasNext: false

  ops: taskGroup().drop()

  groupedTxo: ( ->
    groups = Ember.A()
    items = @get('txo')
    return if Ember.isEmpty(items)

    items.forEach((item) ->
      value = Ember.get(item, 'aa')
      group = groups.find((item) -> Ember.get(item, 'value.address') == Ember.get(value, 'address'))

      if Ember.isPresent(group)
        amount = Ember.get(group, 'amount') + Ember.get(item, 'amount')
        firstcd = Ember.get(group, 'firstcd')
        itemcd = Ember.get(item, 'cd')
        firstcd = itemcd if (itemcd < firstcd)
        Ember.setProperties(group,
          amount: amount
          firstcd: firstcd
        )
        Ember.get(group, 'items').push(item)
      else
        group = { amount: Ember.get(item, 'amount'), firstcd: Ember.get(item, 'cd'), value: value, items: [item] }
        groups.push(group)

    )
    return groups
  ).property('txo.@each.aa')


  selectedTxo: Ember.computed.filterBy('txo', 'selected', true)
  selectedAmounts: Ember.computed.mapBy('selectedTxo', 'amount')
  selectedTotal: Ember.computed.sum('selectedAmounts')


  selectionChanged: (->
    @sendAction('on-change', @get('selectedTotal'), @get('selectedTxo'))
  ).observes('selectedTotal')


  fetchTxo: task(->
    return unless (account = @get('account'))

    try
      res = yield @get('cm.api').getUnspents(account.get('cmo'), sortField: 'creationDate', sortDir: C.DIR_DESCENDING)
      if list = Ember.get(res, 'list')
        @set('txo', list)
        @set('hasNext', Ember.get(res, 'hasNext'))
    catch error
      Ember.Logger.error(error)
  )



  setup: ( ->
    @get('fetchTxo').perform()
    @get('selectedTotal')
  ).on('init').observes('account')


  actions:
    toggleExpanded: (addr) ->
      Ember.set(addr, 'expanded', !Ember.get(addr, 'expanded'))

    selectTxo: (selected, txo, addr) ->
      Ember.set(txo, 'selected', !selected)
      Ember.set(addr, 'selected', Ember.get(addr, 'items')?.isEvery('selected', true))

    selectAddr: (addr) ->
      s = Ember.get(addr, 'selected')
      Ember.set(addr, 'selected', !s)
      Ember.get(addr, 'items')?.forEach((i) -> Ember.set(i, 'selected', !s))
)

`export default AdvancedSrcs`
