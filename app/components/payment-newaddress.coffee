`import Ember from 'ember'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`
`import { task } from 'ember-concurrency'`

PaymentNewaddress = Ember.Component.extend(Alertable,

  service: Ember.inject.service('cm-address-provider')
  cm: Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')

  currentAddress: Ember.computed.alias('service.current.validAddress')
  activeAddress: Ember.computed.alias('service.current.activeAddress')

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
      Ember.Logger.error "Error: ", error

  ).drop()

  updateAddress: task((address, updates) ->
    if address
      try
        yield @get('service').updateActiveAddr(address, updates)
        @set('editAmount', false)
      catch error
        Ember.Logger.error "Error: ", error

  ).drop()

  newActiveAddress: task( ->
    service = @get('service')

    try
      yield service.createActiveAddr('New Special address')
    catch error
      Ember.Logger.error "Error: ", error
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
`export default PaymentNewaddress`
