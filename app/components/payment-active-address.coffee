`import Ember from 'ember'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`
`import { task, taskGroup } from 'ember-concurrency'`
`import config from '../config/environment'`

PAYTO_ROUTE = 'public.payto'
PLACEHOLDER = 'newaddr.active.default-ph'


PaymentNewaddress = Ember.Component.extend(Alertable,

  service: Ember.inject.service('cm-address-provider')
  currencySvc: Ember.inject.service('cm-currency')
  cm: Ember.inject.service('cm-session')
  routing:  Ember.inject.service('-routing')
  i18n: Ember.inject.service()

  activeAddress: Ember.computed.alias('service.current.activeAddress')

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
      @get('activeAddress.cmo.address')
  ).property('wantLink', 'activeAddress', 'publicUrl')

  urlAmount: (->
    if amount = @get('activeAddress.cmo.meta.amount')
      @get('currencySvc').satoshisToBtc(amount)
  ).property('activeAddress.cmo.meta.amount')

  addressUrl: (->
    url = @get('activeAddress.addressURL')
    if addr = @get('activeAddress')
      query = []
      if amount = @get('urlAmount')
        query.pushObject("amount=#{amount}")
      #if info = addr.get('cmo.meta.info')
      #  query.pushObject("message=#{encodeURIComponent(info)}")

      if !Ember.isEmpty(query)
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
      Ember.Logger.error "Error: ", error
  ).group('apiOps')


  updateAddress: task((address, updates) ->
    if address
      try
        yield @get('service').updateAddress(address, updates)
        @set('editAmount', false)
      catch error
        Ember.Logger.error "Error: ", error

  ).group('apiOps')

  newActiveAddress: task( ->
    service = @get('service')

    try
      yield service.createActiveAddr(@get('i18n').t(PLACEHOLDER).toString())
    catch error
      Ember.Logger.error "Error: ", error
  ).drop()


  releaseAddr: task( (addr)->
    service = @get('service')

    try
      yield service.releaseAddress(addr)
      @set('activeAddress', null)
      @sendAction('on-select-active', null)

    catch error
      Ember.Logger.error "Error: ", error
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
  #  Ember.run.scheduleOnce 'afterRender', this, ->
  #    @.$('.info-input').click()

    @get('addressUrl')
    @get('urlAmount')
  ).on('init')

  actions:

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
      amount = @get('currencySvc').parseBtc(amount)
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
