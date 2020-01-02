import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { A } from '@ember/array'
import { isBlank, isEmpty } from '@ember/utils'
import { get, set, getProperties } from '@ember/object'
import { getOwner } from '@ember/application'

import CMCore from 'npm:melis-api-js'
import AbEntry from '../models/ab-entry'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C
NOT_AN_ADDRESS = 'Not a valid coin address.'
NOT_AN_ALIAS = 'Not a valid CM Alias.'



EditAbEntry = Component.extend(

  cm: service('cm-session')
  ab: service('cm-addressbook')
  scanner: service('scanner-provider')
  coinsvc: service('cm-coin')

  value: null
  edit: false

  coin: alias('value.coin')

  'new-address': null

  apiOps: taskGroup().drop()

  contactTypes: A([
    {id: C.AB_TYPE_MELIS , label: 'ab.form.t.melis'}
    {id: C.AB_TYPE_ADDRESS, label: 'ab.form.t.addr'}
  ])


  availableCoins: alias('coinsvc.coins')

  selectedCoin: ( ->
    if c = @get('coin')
      @get('availableCoins').findBy('unit', c)
  ).property('coin', 'availableCoins')


  currentType: ( ->

    @get('contactTypes').findBy('id', @get('value.type'))
  ).property('value.type')


  checkDupes: (pubId)->
    if !isBlank(cmalias = @get('value.alias')) && pubId
      matches = @get('ab.store').find('ab-entry', {val: pubId})
      if !isEmpty(matches) && !@get('edit')
        @set('aliasError', 'Duplicate entry.')
        return true



  scanAddress: task( ->
    try
      data = yield @get('scanner').independentScan()
      if (address = @get('scanner').getAddressFromData(data))
        @set('value.address', address)
    catch err
      Logger.error "Scanner aborted: ", err
  )

  checkAlias: task( ->
    @set('aliasError', false)
    if !isBlank(cmalias = @get('value.alias'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: cmalias)
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
          Logger.error "Error: ", err

  ).group('apiOps')


  submitEntry: task( ->
    yield @get('checkAlias').perform()
    if @get('value.isValid')
      @sendAction('on-save', @get('value'))
  )

  valueChanged: ( -> @set('coin', @get('availableCoins.firstObject.unit')) if !@get('coin')).observes('value')


  actions:
    selectCoin: (c) ->
      if unit = get(c, 'unit')
        @set('coin', unit)

    changeType: (type)->
      if type
        @set('value.type', get(type, 'id'))

    lookupAlias: (deferred)->
      @get('checkAlias').perform()

    submitEntry: ->
      @get('submitEntry').perform()

    scanAddress: ->
      @get('scanAddress').perform()

    updateLabels: (labels) ->
      @set('value.labels', labels)

  resetContent: (initial)->
    @set 'value', AbEntry.create(
      getOwner(this).ownerInjection()
      type: C.AB_TYPE_ADDRESS
      name: null
      address: initial
      alias: null
      labels: A()
      coin: @get('availableCoins.firstObject.unit')
    )


  setup: ( ->

    if isBlank(@get('value'))
      @resetContent(@get('new-address'))
    else if @get('edit')
      @get('checkAlias').perform()
  ).on('init')

)

export default EditAbEntry


