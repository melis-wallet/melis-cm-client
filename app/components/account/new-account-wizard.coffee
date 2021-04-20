import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, equal } from '@ember/object/computed'
import { get } from '@ember/object'
import { A } from '@ember/array'

import CMCore from 'melis-api-js'
import { validator, buildValidations } from 'ember-cp-validations'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import { task, taskGroup } from 'ember-concurrency'


import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C


Validations = buildValidations(
  accountName: [
    validator('presence', true)
    validator('length', min: 1, max: 32)
  ]

  selectedScheme: [
    validator('presence', true)
  ]
)

NewAccountWizard = Component.extend(AsWizard, Validations, 

  cm: service('cm-session')
  coinsvc: service('cm-coin')

  apiOps: taskGroup().drop()

  joinAccount: false

  step: 1
  stepBack: true

  accountName: null

  type: null
  isMulti: equal('type', 'multi')

  wantsServer: true

  masterName: 'Master'
  masterMandatory: false

  coin: null

  cosignersCnt: alias('cosigners.length')

  totalSignatures: ( ->
    @get('cosignersCnt') + 1
  ).property('cosignersCnt')

  minSignatures: null

  cosigners: null

  createError: null
  serverLocked: false
  newAccount: null

  completeOn: ( ->
    if @get('isMulti')
      5
    else
      4
  ).property('isMulti')


  availableCoins: alias('coinsvc.enabledCoins')

  selectedCoin: ( ->
    if c = @get('coin')
      @get('availableCoins').findBy('unit', c)
  ).property('coin', 'availableCoins')

  coin: null

  selectedScheme: ( ->
    { type, wantsServer } = @getProperties('type', 'wantsServer')

    switch type
      when 'single'
        if wantsServer
          C.TYPE_2OF2_SERVER
        else
          C.TYPE_PLAIN_HD
      when 'multi'
        if wantsServer
          C.TYPE_MULTISIG_MANDATORY_SERVER
        else
          C.TYPE_MULTISIG_NO_SERVER

  ).property('type', 'wantsServer')


  accountCreateTask: task((data) ->
    @set('createError', null)

    try
      account = yield @get('cm').accountCreate(data)
      @set('newAccount', account)
    catch error
      Logger.error("Create Account failed:", error)
      if error.ex == 'CmServerLockedException'
        @set('serverLocked', true)
      else
        @set('createError', error)

  ).group('apiOps')

  accountCreate: ->
    cm = @get('cm')
    { coin,
      accountName,
      masterName,
      masterMandatory,
      minSignatures,
      selectedScheme } = @getProperties('coin', 'accountName', 'masterName', 'masterMandatory', 'minSignatures', 'selectedScheme')


    if @get('isMulti')
      cosigners = @get('cosigners').map( (i)->
        { name: i.name, mandatory: i.mandatory }
      )
      minSignatures = @get('minSignatures')
    else
      cosigners = []
      minSignatures = null
      masterName = null

    @get('accountCreateTask').perform(
      coin: coin
      type: selectedScheme
      meta: {name: accountName, masterName: masterName}
      pubMeta: {name: accountName}
      minSignatures: minSignatures
      mandatorySignature: masterMandatory
      cosigners: cosigners
    )


  setup: ( ->
    @setProperties
      cosigners: A()
      #coin: @get('availableCoins.firstObject.unit')
  ).on('init')

  finishWizard: (account) ->
    if modal = @get('modal')
      modal.close(true).then( =>

        @sendAction('on-wizard-finish', account)
      )
    else
      @sendAction('on-wizard-finish', account)

  actions:
    selectCoin: (c) ->
      if unit = get(c, 'unit')
        @set('coin', unit)

    destroyWizard: ->
      # not sure, but lets do this
      if newA = @get('newAccount.pubId')
        @get('cm').selectAccount(newA)

      @finishWizard(@get('newAccount'))


    'complete-step': (value) ->
      @markCompleted(value)
      @set('step', value + 1)

    doJoinAcc: ->
      @set('joinAccount', true)

    cancelJoinAcc: ->
      @set('joinAccount', false)

    doneJoinAcc: (account) ->
      @finishWizard(account)

    doneNameSelect: ->
      @markCompleted()
      @accountCreate()

    doneCosigners: (data) ->
      @setProperties(data)
      @markCompleted(4, 5)

    typeSelected: ->
      if @get('type')
        @markCompleted(2, 3)

    coinSelected: ->
      if @get('coin')
        @markCompleted(1, 2)

    serverSelected: ->
      @markCompleted(3, 4)

    singleAccount: ->
      @set('type', 'single')

    multiAccount: ->
      @set('type', 'multi')


    noServer: ->
      @set('wantsServer', false)

    withServer: ->
      @set('wantsServer', true)
)

export default NewAccountWizard
