import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { isEmpty } from '@ember/utils'
import { get } from '@ember/object'
import RSVP from 'rsvp'

import Logger from 'melis-cm-svcs/utils/logger'

import { task, taskGroup } from 'ember-concurrency'
import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'

AddressDetail = Component.extend(

  address: null

  cm: service('cm-session')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')
  mm: service('modals-manager')
  aa: service('aa-provider')

  showControls: false

  wantLink: false
  signId: 'sign-msg'

  wif: null

  isActive: (->

    !(isEmpty(@get('address.meta')) && isEmpty(@get('address.labels')))
  ).property('address.meta', 'address.label')

  code: ( ->
    if @get('wantLink')
      @get('publicUrl')
    else
      @get('addressUrl')
  ).property('address', 'wantLink', 'addressUrl', 'publicUrl')

  clipCode: ( ->
    if @get('wantLink')
      @get('publicUrl')
    else
      @get('address.address')
  ).property('wantLink', 'address', 'publicUrl')

  urlAmount: (->
    if amount = @get('address.meta.amount')
      @get('currencySvc').satoshisToCoin(amount)
  ).property('address.meta.amount')


  addressUrl: (->
    address = @get('address.address')
    url = "bitcoin:#{address}"

    if addr = @get('address')
      query = []
      if amount = @get('urlAmount')
        query.pushObject("amount=#{amount}")

      if !isEmpty(query)
        url += '?' + query.join('?')

    url
  ).property('address.addressURL',  'urlAmount', 'address.meta.info')


  apiOps: taskGroup().drop()

  releaseAddr: task( (address) ->
    try
      d = yield @get('cm.api').addressUpdate(@get('cm.currentAccount.cmo'), get(address, 'address'), null, null)
      @sendAction('on-address-change', d)
    catch error
      Logger.error "Error: ", error
  ).group('apiOps')


  updateAddress: task((address, updates) ->
    #return unless address

    updates ||= {}
    meta = mergedProperty(address, 'meta', filterProperties(updates, 'info', 'amount'))
    labels = get(updates, 'labels') || get(address, 'labels')

    if address
      try
        d = yield @get('cm.api').addressUpdate(@get('cm.currentAccount.cmo'), get(address, 'address'), labels, meta)
        @sendAction('on-address-change', d)
      catch error
        Logger.error "Error: ", error
  ).group('apiOps')


  signWithAddr: task(->
    try
      yield @get('mm').showModal(@get('signId'))
    catch error

  )

  exportKey: task((addr)->
    account = @get('cm.currentAccount.cmo')
    api = @get('cm.api')

    op = (tfa) =>
      RSVP.resolve(api.exportAddressKeyToWIF(account, addr))


    try
      wif = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
      @set('wif', wif)
    catch error
      Logger.error "Error: ", error
  )



  actions:

    signWithAddr: ->
      if addr = @get('address')
        @get('signWithAddr').perform()
      false

    releaseAddr: ->
      if addr = @get('address')
        @get('releaseAddr').perform(addr)

    changeLabels: (labels) ->
      addr = @get('address')
      @get('updateAddress').perform(addr, labels: labels)

    changeInfo: (info) ->
      addr = @get('address')
      @get('updateAddress').perform(addr, info: info)

    exportKey:  ->
      addr = @get('address')
      if addr && @get('cm.currentAccount.canSignMessage')
        @get('exportKey').perform(addr)
      false

    trashKey: () ->
      @set('wif', null)
)

export default AddressDetail
