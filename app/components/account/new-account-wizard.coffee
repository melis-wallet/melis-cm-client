`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'`
`import { task, taskGroup } from 'ember-concurrency'`

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

NewAccountWizard = Ember.Component.extend(AsWizard, Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')

  apiOps: taskGroup().drop()

  joinAccount: false

  step: 1
  stepBack: true

  accountName: null

  type: null
  isMulti: Ember.computed.equal('type', 'multi')

  wantsServer: true

  masterName: 'Master'
  masterMandatory: false

  cosignersCnt: Ember.computed.alias('cosigners.length')

  totalSignatures: ( ->
    @get('cosignersCnt') + 1
  ).property('cosignersCnt')

  minSignatures: null

  cosigners: null

  step: 1

  createError: null
  serverLocked: false
  newAccount: null

  completeOn: ( ->
    if @get('isMulti')
      4
    else
      3
  ).property('isMulti')


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
      Ember.Logger.error("Create Account failed:", error)
      if error.ex == 'CmServerLockedException'
        @set('serverLocked', true)
      else
        @set('createError', error)

  ).group('apiOps')

  accountCreate: ->
    cm = @get('cm')
    { accountName,
      masterName,
      masterMandatory,
      minSignatures,
      selectedScheme } = @getProperties('accountName', 'masterName', 'masterMandatory', 'minSignatures', 'selectedScheme')


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
      type: selectedScheme
      meta: {name: accountName, masterName: masterName}
      pubMeta: {name: accountName}
      minSignatures: minSignatures
      mandatorySignature: masterMandatory
      cosigners: cosigners
    )


  setup: ( ->
    @set('cosigners', Ember.A())
  ).on('init')

  finishWizard: (account) ->
    if modal = @get('modal')
      modal.close(true).then( =>

        @sendAction('on-wizard-finish', account)
      )
    else
      @sendAction('on-wizard-finish', account)

  actions:
    destroyWizard: ->
      # not sure, but lets do this
      if newA = @get('newAccount.num')
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
      @markCompleted(3, 4)

    typeSelected: ->
      if @get('type')
        @markCompleted(1, 2)

    serverSelected: ->
      @markCompleted(2, 3)

    singleAccount: ->
      @set('type', 'single')

    multiAccount: ->
      @set('type', 'multi')


    noServer: ->
      @set('wantsServer', false)

    withServer: ->
      @set('wantsServer', true)
)
`export default NewAccountWizard`
