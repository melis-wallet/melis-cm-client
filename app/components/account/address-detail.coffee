`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'`

AddressDetail = Ember.Component.extend(

  address: null

  cm: Ember.inject.service('cm-session')
  currencySvc: Ember.inject.service('cm-currency')
  mm: Ember.inject.service('modals-manager')
  aa: Ember.inject.service('aa-provider')

  showControls: false

  wantLink: false
  signId: 'sign-msg'

  wif: null

  isActive: (->

    !(Ember.isEmpty(@get('address.meta')) && Ember.isEmpty(@get('address.labels')))
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

      if !Ember.isEmpty(query)
        url += '?' + query.join('?')

    url
  ).property('address.addressURL',  'urlAmount', 'address.meta.info')


  apiOps: taskGroup().drop()

  releaseAddr: task( (address) ->
    try
      d = yield @get('cm.api').addressUpdate(@get('cm.currentAccount.cmo'), Ember.get(address, 'address'), null, null)
      @sendAction('on-address-change', d)
    catch error
      Ember.Logger.error "Error: ", error
  ).group('apiOps')


  updateAddress: task((address, updates) ->
    #return unless address

    updates ||= {}
    meta = mergedProperty(address, 'meta', filterProperties(updates, 'info', 'amount'))
    labels = Ember.get(updates, 'labels') || Ember.get(address, 'labels')

    if address
      try
        d = yield @get('cm.api').addressUpdate(@get('cm.currentAccount.cmo'), Ember.get(address, 'address'), labels, meta)
        @sendAction('on-address-change', d)
      catch error
        Ember.Logger.error "Error: ", error
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
      Ember.RSVP.resolve(api.accountAddressToWIF(account, addr))


    try
      wif = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
      @set('wif', wif)
    catch error
      Ember.Logger.error "Error: ", error
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

`export default AddressDetail`
