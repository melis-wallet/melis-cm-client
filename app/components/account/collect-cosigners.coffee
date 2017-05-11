`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

C = CMCore.C


Validations = buildValidations(
  masterName: [
    validator('presence', true)
    validator('length', min: 1, max: 31)
  ]
)

CollectCosigners = Ember.Component.extend(Validations, ValidationsHelper, ModelFactory,

  info: Ember.inject.service('cm-account-info')

  withServer: false
  accountType: null

  cosigners: null
  minSignatures: 2
  currentCosigner: null

  cosignersCnt: Ember.computed.alias('cosigners.length')
  totalSignatures: ( ->
    @get('cosignersCnt') + 1
  ).property('cosignersCnt')

  masterName: null
  masterMandatory: false
  masterChanged: false
  reviewMaster: false


  allMandatory: ( ->
    @get('minSignatures') == @get('totalSignatures')
  ).property('totalSignatures', 'minSignatures')

  cannotSetMandatory: ( ->
    @get('allMandatory') || (@get('minSignatures') < 1)
  ).property('minSignatures', 'allMandatory')

  #maxMandatory: Ember.computed.alias('minSignatures')

  maxMandatory: (->
    (@get('minSignatures') - 1)
  ).property('minSignatures')

  readonlyCs: ( ->
    @get('mandatoryCnt') == @get('minSignatures')
  ).property('minSignatures', 'mandatoryCnt')

  mandatoryCosigners: ( ->
    @get('cosigners').filterBy('mandatory', true)
  ).property('cosigners.@each.mandatory')

  mandatoryCnt: ( ->
    @get('mandatoryCosigners.length') + (1 * @get('masterMandatory'))
  ).property('mandatoryCosigners.length', 'masterMandatory')

  checkMaxSigs: ( ->
    total = @get('totalSignatures')
    if @get('minSignatures') > total
      @set('minSignatures', total)

    if (@get('mandatoryCnt') > @get('maxMandatory'))
      if (c = @get('mandatoryCosigners').get('firstObject'))
        c.set('mandatory', false)
      else if @get('masterMandatory')
        @set('masterMandatory', false)
  ).observes('minSignatures', 'totalSignatures')

  validState: (->
    return false unless @get('isValid')
    if (s = @get('currentCosigner'))
      s.get('isValid')
    else
      true
  ).property('isValid', 'currentCosigner', 'currentCosigner.isValid')


  feeEstimate: (->
    @get('info').estimateFees(@get('totalSignatures'), @get('minSignatures'), @get('withServer'))
  ).property('withServer', 'totalSignatures', 'minSignatures')

  canDelete: (->
    (@get('cosignersCnt') > 1)
  ).property('cosignersCnt')

  setup: ( ->

    @set 'cosigners', Ember.A()
    cosigner = @createSimpleModel('account-cosigner', name: null)
    @get('cosigners').pushObject(cosigner)

    @setProperties(
      currentCosigner: cosigner
      masterName: @get('i18n').t('account.cosigners.you')
    )

  ).on('init')


  focusInput: ( ->
    Ember.run.scheduleOnce('afterRender', this, ->
      @.$('input.ember-text-field').focus().click()
    )
  )

  doEditMaster: ->
    if @get('validState')
      if !@get('masterChanged')
        @set 'masterName', null
      @setProperties
        currentCosigner: null
        editMaster: true
        masterChanged: true
      @focusInput()

  doneEditMaster: ->
    if @get('validState')
      @setProperties
        currentCosigner: null
        editMaster: false

  actions:
    done: ->
      if !@get('masterChanged')
        @set('reviewMaster', true)
        @doEditMaster()
      else
        @set('reviewMaster', false)
        @sendAction('on-done', @getProperties('cosigners', 'masterName', 'masterMandatory', 'minSignatures'))


    selectSigner: (signer) ->
      if @get('validState')
        if signer == @get('currentCosigner')
          @set 'currentCosigner', null
        else
          @set 'editMaster', false
          @set 'currentCosigner', signer
          @focusInput()
      else
        @get('currentCosigner')?.validate()

    toggleEditMaster: ->
      if @get('editMaster')
        @doneEditMaster()
      else
        @doEditMaster()

    doneEditMaster: ->
      @doneEditMaster()

    doneMaster: ->
      if @get('isValid')
        @set 'editMaster', false

    doneSigner: ->
      if @get('currentCosigner.isValid')
        @set 'currentCosigner', null

    addSigner: ->
      if @get('validState')
        cosigner = @createSimpleModel('account-cosigner', name: null)
        @get('cosigners').pushObject(cosigner)
        @setProperties
          currentCosigner: cosigner
          editMaster: false

    deleteCurrent: ->
      if @get('canDelete') && (cosigner = @get('currentCosigner'))
        @get('cosigners').removeObject(cosigner)
        @set('currentCosigner', null)


    setMandatory: (state, cosigner) ->
      if state && (@get('mandatoryCnt') >= @get('maxMandatory'))
        if (c = @get('mandatoryCosigners').get('firstObject'))
          c.set('mandatory', false)
          Ember.set(cosigner, 'mandatory', true )
        else if @get('masterMandatory')
          @set('masterMandatory', false)
          Ember.set(cosigner, 'mandatory', true )
      else
        Ember.set(cosigner, 'mandatory', state)

    setMasterMandatory: (state) ->
      if state && (@get('mandatoryCnt') >= @get('maxMandatory'))
        if (c = @get('mandatoryCosigners').get('firstObject'))
          c.set('mandatory', false)
          @set('masterMandatory', true)
      else
        @set('masterMandatory', state)

)
`export default CollectCosigners`
