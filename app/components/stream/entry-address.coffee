import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty, equal } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'

import { task, taskGroup } from 'ember-concurrency'
import config from '../../config/environment'

import Logger from 'melis-cm-svcs/utils/logger'


PAYTO_ROUTE = 'public.payto'
PLACEHOLDER = 'newaddr.active.default-ph'


StreamAddress = Component.extend(

  cm: service('cm-session')
  addrsvc: service('cm-address-provider')
  routing: service('-routing')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')

  entry: null

  classNames: ['stream-entry', 'row','animated', 'fadeIn', 'quick']

  address: alias('entry.content')
  format: alias('address.format')

  isStandard: equal('format', 'standard')
  showToggle: alias('address.coin.features.altaddrs')

  used: notEmpty('address.usedIn')

  showControls: false

  wantLink: false

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
      @get('address.displayAddress')
  ).property('wantLink', 'address.displayAddress', 'publicUrl')

  urlAmount: (->
    if amount = @get('address.cmo.meta.amount')
      @get('currencySvc').satoshisToCoin(amount)
  ).property('address.cmo.meta.amount')


  addressUrl: (->
    url = @get('address.addressURL')
    if addr = @get('address')
      query = []
      if amount = @get('urlAmount')
        query.pushObject("amount=#{amount}")
      #if info = addr.get('cmo.meta.info')
      #  query.pushObject("message=#{encodeURIComponent(info)}")

      if !isEmpty(query)
        url += '?' + query.join('?')

    url
  ).property('address.addressURL',  'urlAmount', 'address.cmo.meta.info')

  publicUrl: (->
    if addr = @get('address')
      params = {
        addr: addr.get('cmo.address')
        amount: addr.get('cmo.meta.amount')
      }

      uid = encodeURIComponent(@get('address.account.uniqueId'))
      routeSeg = @get('routing').generateURL(PAYTO_ROUTE, [uid], params)
      config.APP.publicUrl + routeSeg
  ).property('address.cmo.address', 'address.cmo.meta.amount')


  apiOps: taskGroup().drop()

  releaseAddr: task( (addr)->
    service = @get('addrsvc')
    try
      yield service.releaseAddress(addr)
    catch error
      Logger.error "Error: ", error

  ).group('apiOps')


  updateAddress: task((address, updates) ->
    if address
      try
        yield @get('addrsvc').updateAddress(address, updates)
      catch error
        Logger.error "Error: ", error
  ).group('apiOps')


  clickable: ( ->
    !@get('showControls') && !@get('used')
  ).property('showControls', 'used')

  whenUsed: ( ->
    if @get('used')
      @set('showControls', false)
  ).observes('used')

  actions:


    toggleFormat: ->
      if @get('isStandard')
        @set('format', 'legacy')
      else
        @set('format', 'standard')

    selectUsedTx: ->
      # TBD


    releaseAddr: ->
      if addr = @get('address')
        @get('releaseAddr').perform(addr)

    changeAmount: (amount) ->
      amount = @get('coinsvc').parseUnit(@get('entry.account'), amount)
      addr = @get('address')
      @get('updateAddress').perform(addr, amount: amount)

    changeInfo: (info) ->
      addr = @get('address')
      @get('updateAddress').perform(addr, info: info)

    changeLabels: (labels) ->
      addr = @get('address')
      @get('updateAddress').perform(addr, labels: labels)

    toggleControls: ->
      @toggleProperty('showControls')

    showControls: ->
      if @get('clickable')
        @set('showControls', true)

    hideControls: ->
      @set('showControls', false)
)


export default StreamAddress
