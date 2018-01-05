`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import groupBy from '../../utils/group-by'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C

UtxoList = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  mm: Ember.inject.service('modals-manager')
  aa: Ember.inject.service('aa-provider')
  txsvc: Ember.inject.service('cm-tx-infos')


  account: null
  txo: null
  hasNext: false

  signId: 'sign-msg'
  activeAddr: null

  ops: taskGroup().drop()

  groupedTxo: ( ->
    groups = Ember.A()
    items = @get('txo')
    return if Ember.isEmpty(items)

    items.forEach((item) ->
      value = Ember.get(item, 'aa')
      group = groups.find((item) -> Ember.get(item, 'value.address') == Ember.get(value, 'address') )

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


  signWithAddr: task((addr) ->
    try
      @set('activeAddr', addr)
      yield @get('mm').showModal(@get('signId'))
    catch error
      Ember.Logger.error "Error: ", error

  ).group('ops')

  exportKey: task((addr)->
    account = @get('account.cmo')
    api = @get('cm.api')

    op = (tfa) =>
      Ember.RSVP.resolve(api.accountAddressToWIF(account, addr))


    try
      wif = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
      Ember.set(addr, 'wif', wif)
    catch error
      Ember.Logger.error "Error: ", error
  ).group('ops')


  setup: ( ->
    @get('fetchTxo').perform()
  ).on('init').observes('account')


  actions:
    toggleExpanded: (addr) ->
      Ember.set(addr, 'expanded', !Ember.get(addr, 'expanded'))

    signWithAddr: (addr) ->
      if addr && @get('account.canSignMessage')
        @get('signWithAddr').perform(addr)
      false


    exportKey: (addr) ->
      if addr && @get('account.canSignMessage')
        @get('exportKey').perform(addr)
      false


    trashKey: (addr) ->
      Ember.set(addr, 'wif', null)


)


`export default UtxoList`
