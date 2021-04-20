import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get, set, setProperties } from '@ember/object'
import { A } from '@ember/array'
import { isEmpty, isPresent } from '@ember/utils'
import RSVP from 'rsvp'

import { task, taskGroup } from 'ember-concurrency'
import groupBy from '../../utils/group-by'
import CMCore from 'melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C

UtxoList = Component.extend(

  cm: service('cm-session')
  mm: service('modals-manager')
  aa: service('aa-provider')
  txsvc: service('cm-tx-infos')


  account: null
  txo: null
  hasNext: false

  signId: 'sign-msg'
  activeAddr: null

  ops: taskGroup().drop()

  groupedTxo: ( ->
    groups = A()
    items = @get('txo')
    return if isEmpty(items)

    items.forEach((item) ->
      value = get(item, 'aa')
      group = groups.find((item) -> get(item, 'value.address') == get(value, 'address') )

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


  signWithAddr: task((addr) ->
    try
      @set('activeAddr', addr)
      yield @get('mm').showModal(@get('signId'))
    catch error
      Logger.error "Error: ", error

  ).group('ops')

  exportKey: task((addr)->
    account = @get('account.cmo')
    api = @get('cm.api')

    op = (tfa) =>
      RSVP.resolve(api.exportAddressKeyToWIF(account, addr))


    try
      wif = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
      set(addr, 'wif', wif)
    catch error
      Logger.error "Error: ", error
  ).group('ops')


  setup: ( ->
    @get('fetchTxo').perform()
  ).on('init').observes('account')


  actions:
    toggleExpanded: (addr) ->
      set(addr, 'expanded', !get(addr, 'expanded'))

    signWithAddr: (addr) ->
      if addr && @get('account.canSignMessage')
        @get('signWithAddr').perform(addr)
      false


    exportKey: (addr) ->
      if addr && @get('account.canSignMessage')
        @get('exportKey').perform(addr)
      false


    trashKey: (addr) ->
      set(addr, 'wif', null)

)


export default UtxoList
