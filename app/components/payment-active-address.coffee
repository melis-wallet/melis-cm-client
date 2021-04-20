import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, equal } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import { scheduleOnce } from '@ember/runloop'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import { task, taskGroup } from 'ember-concurrency'
import config from '../config/environment'

import Logger from 'melis-cm-svcs/utils/logger'


PAYTO_ROUTE = 'public.payto'
PLACEHOLDER = 'newaddr.active.default-ph'


PaymentNewaddress = Component.extend(Alertable,

  service: service('cm-address-provider')
  currencySvc: service('cm-currency')
  coinsvc: service('cm-coin')
  cm: service('cm-session')
  routing:  service('-routing')
  i18n: service()

  activeAddress: alias('service.current.activeAddress')
  format: alias('activeAddress.format')

  isStandard: equal('format', 'standard')

  showToggle: alias('activeAddress.coin.features.altaddrs')

  showCode: true

  wantLink: false

  apiOps: taskGroup().drop()

  code: ( ->
    if @get('wantLink')
      @get('publicUrl')
    else
      @get('addressUrl')
  ).property('activeAddress', 'wantLink', 'addressUrl', 'publicUrl')

  clipCode: ( ->
    if @get('wantLink')
      @get('publicUrl')
    else
      @get('activeAddress.displayAddress')
  ).property('wantLink', 'activeAddress.displayAddress', 'publicUrl')

  urlAmount: (->
    if amount = @get('activeAddress.cmo.meta.amount')
      @get('currencySvc').satoshisToCoin(amount)
  ).property('activeAddress.cmo.meta.amount')

  addressUrl: (->
    url = @get('activeAddress.addressURL')
    if addr = @get('activeAddress')
      query = []
      if amount = @get('urlAmount')
        query.pushObject("amount=#{amount}")
      #if info = addr.get('cmo.meta.info')
      #  query.pushObject("message=#{encodeURIComponent(info)}")

      if !isEmpty(query)
        url += '?' + query.join('?')

    url
  ).property('activeAddress.addressURL',  'urlAmount', 'activeAddress.cmo.meta.info')

  publicUrl: (->
    if addr = @get('activeAddress')
      params = {
        addr: addr.get('cmo.address')
        amount: addr.get('cmo.meta.amount')
      }

      uid = encodeURIComponent(@get('activeAddress.account.uniqueId'))
      routeSeg = @get('routing').generateURL(PAYTO_ROUTE, [uid], params)
      config.APP.publicUrl + routeSeg
  ).property('activeAddress.cmo.address', 'activeAddress.cmo.meta.amount')


  makeCurrentActive: task( (info) ->
    @set 'error', null
    try
      addr = yield @get('service').requestFromCurrent(null, info: info)
      @sendAction('on-select-active', addr)
    catch error
      @set 'error', error
      Logger.error "Error: ", error
  ).group('apiOps')


  updateAddress: task((address, updates) ->
    if address
      try
        yield @get('service').updateAddress(address, updates)
        @set('editAmount', false)
      catch error
        Logger.error "Error: ", error

  ).group('apiOps')

  newActiveAddress: task( ->
    svc = @get('service')

    try
      yield svc.createActiveAddr(@get('i18n').t(PLACEHOLDER).toString())
    catch error
      Logger.error "Error: ", error
  ).drop()


  releaseAddr: task( (addr)->
    svc = @get('service')

    try
      yield svc.releaseAddress(addr)
      @set('activeAddress', null)
      @sendAction('on-select-active', null)

    catch error
      Logger.error "Error: ", error
  ).group('apiOps')

  updateCurrentAddress: (data) ->
    @get('service').updateCurrentAddress(data)


  observeHint: ( ->
    if  @get('service.current.fetched') && (address = @get('hinted'))
      @get('service').makeThisActive(address)
  ).observes('hinted', 'service.current.fetched', 'cm.currentAccount').on('didInsertElement')

  observeCode: ( ->
    @sendAction('on-code-change', @get('code'))
  ).observes('code').on('didInsertElement')

  setup: ( ->
  #  scheduleOnce 'afterRender', this, ->
  #    @.$('.info-input').click()

    @get('addressUrl')
    @get('urlAmount')
  ).on('init')

  actions:

    toggleFormat: ->
      if @get('isStandard')
        @set('format', 'legacy')
      else
        @set('format', 'standard')

    leaveAddr: ->
      @set('activeAddress', null)

    releaseAddr: ->
      addr = @get('activeAddress')
      @get('releaseAddr').perform(addr)

    newActiveAddress: ->
      @get('service').requestNewAddress()


    makeCurrentActive: ->
      @get('makeCurrentActive').perform(@get('i18n').t(PLACEHOLDER).toString)


    changeAmount: (amount) ->
      amount = @get('coinsvc').parseUnit(@get('cm.currentAccount'), amount)
      addr = @get('activeAddress')
      @get('updateAddress').perform(addr, amount: amount)


    changeInfo: (info) ->
      addr = @get('activeAddress')
      @get('updateAddress').perform(addr, info: info)

    changeLabels: (labels) ->
      addr = @get('activeAddress')
      @get('updateAddress').perform(addr, labels: labels)


)
`export default PaymentNewaddress`
