import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, equal } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import { scheduleOnce } from '@ember/runloop'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import { task } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

PaymentNewaddress = Component.extend(Alertable,

  service: service('cm-address-provider')
  cm: service('cm-session')
  coinsvc: service('cm-coin')

  currentAddress: alias('service.current.validAddress')
  activeAddress: alias('service.current.activeAddress')

  newAddress: null

  hideCode: false

  wantLink: false

  activeUrl: ( ->
    if @get('wantLink')
      "FOOO"
    else
      @get('activeAddress.addressURL')
  ).property('wantLink')


  makeCurrentActive: task( (info) ->
    try
      yield @get('service').makeCurrentActive(info: info)
    catch error
      Logger.error "Error: ", error

  ).drop()

  updateAddress: task((address, updates) ->
    if address
      try
        yield @get('service').updateActiveAddr(address, updates)
        @set('editAmount', false)
      catch error
        Logger.error "Error: ", error

  ).drop()

  newActiveAddress: task( ->
    svc = @get('service')

    try
      yield svc.createActiveAddr('New Special address')
    catch error
      Logger.error "Error: ", error
  ).drop()

  updateCurrentAddress: (data) ->
    @get('service').updateCurrentAddress(data)


  actions:

    submitAddress: ->
      @sendAction('on-new-address', @get('newAddress'))

    deleteAddress: ->
      @sendAction('on-delete-address')

    refreshAddress: ->
      @get('service')

    editAddress: ->
      @set('showForm', true)

    newActiveAddress: ->
      @get('service').requestNewAddress()

    makeCurrentActive: ->
      @get('makeCurrentActive').perform('New Special address')

    changeAmount: (amount) ->
      amount = @get('coinsvc').parseUnit(@get('cm.currentAccount'), amount)
      addr = @get('currentAddress')
      @get('updateAddress').perform(addr, amount: amount)

    changeInfo: (info) ->
      addr = @get('currentAddress')
      @get('updateAddress').perform(addr, info: info)



)

export default PaymentNewaddress
