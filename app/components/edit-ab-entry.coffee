`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import AbEntry from '../models/ab-entry'`
`import { task, taskGroup } from 'ember-concurrency'`



C = CMCore.C
NOT_AN_ADDRESS = 'Not a valid bitcoin address.'
NOT_AN_ALIAS = 'Not a valid CM Alias.'



EditAbEntry = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  ab: Ember.inject.service('cm-addressbook')
  scanner: Ember.inject.service('scanner-provider')
  coinsvc: Ember.inject.service('cm-coin')

  value: null
  edit: false

  coin: Ember.computed.alias('value.coin')

  'new-address': null

  apiOps: taskGroup().drop()

  contactTypes: Ember.A([
    {id: C.AB_TYPE_MELIS , label: 'Another Melis User'}
    {id: C.AB_TYPE_ADDRESS, label: 'Generic Bitcoin Address'}
  ])


  availableCoins: Ember.computed.alias('coinsvc.coins')

  selectedCoin: ( ->
    if c = @get('coin')
      @get('availableCoins').findBy('unit', c)
  ).property('coin', 'availableCoins')


  currentType: ( ->

    @get('contactTypes').findBy('id', @get('value.type'))
  ).property('value.type')


  checkDupes: (pubId)->
    if !Ember.isBlank(alias = @get('value.alias')) && pubId
      matches = @get('ab.store').find('ab-entry', {val: pubId})
      if !Ember.isEmpty(matches) && !@get('edit')
        @set('aliasError', 'Duplicate entry.')
        return true



  scanAddress: task( ->
    try
      data = yield @get('scanner').independentScan()
      if (address = @get('scanner').getAddressFromData(data))
        @set('value.address', address)
    catch err
      Ember.Logger.error "Scanner aborted: ", err
  )

  checkAlias: task( ->
    @set('aliasError', false)
    if !Ember.isBlank(alias = @get('value.alias'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: alias)
        console.error res
        @set('accountInfo', res)
        if @checkDupes(res.pubId)
          @set('value.pubId', null)
        else
          @set('value.pubId', res.pubId)
          @set('coin', res.coin)
        res
      catch err
        if err.ex = 'CmInvalidAccountException'
          @setProperties
            accountInfo: null
            aliasError: 'Alias not found'
          @set('value.pubId', null)
        else
          Ember.Logger.error "Error: ", err

  ).group('apiOps')


  submitEntry: task( ->
    alias = yield @get('checkAlias').perform()
    if @get('value.isValid')
      @sendAction('on-save', @get('value'))
  )

  valueChanged: ( -> @set('coin', @get('availableCoins.firstObject.unit')) if !@get('coin')).observes('value')


  actions:
    selectCoin: (c) ->
      if unit = Ember.get(c, 'unit')
        @set('coin', unit)

    changeType: (type)->
      if type
        console.error 'type', type
        @set('value.type', Ember.get(type, 'id'))

    lookupAlias: (deferred)->
      @get('checkAlias').perform()

    submitEntry: ->
      @get('submitEntry').perform()

    scanAddress: ->
      @get('scanAddress').perform()


  resetContent: (initial)->
    @set 'value', AbEntry.create(
      Ember.getOwner(this).ownerInjection()
      type: C.AB_TYPE_ADDRESS
      name: null
      address: initial
      alias: null
      labels: Ember.A()
      coin: @get('availableCoins.firstObject.unit')
    )


  setup: ( ->

    if Ember.isBlank(@get('value'))
      @resetContent(@get('new-address'))
    else if @get('edit')
      @get('checkAlias').perform()
  ).on('init')

)

`export default EditAbEntry`


