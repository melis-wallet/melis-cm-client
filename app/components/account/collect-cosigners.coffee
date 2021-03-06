import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { A } from '@ember/array'
import { get, set } from '@ember/object'
import { scheduleOnce } from '@ember/runloop'

import CMCore from 'melis-api-js'
import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'
import { validator, buildValidations } from 'ember-cp-validations'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C


Validations = buildValidations(
  masterName: [
    validator('presence', true)
    validator('length', min: 1, max: 31)
  ]
)

CollectCosigners = Component.extend(Validations, ModelFactory,

  info: service('cm-account-info')

  withServer: false
  accountType: null

  cosigners: null
  minSignatures: 2
  currentCosigner: null

  cosignersCnt: alias('cosigners.length')
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

  #maxMandatory: alias('minSignatures')

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
    return false unless @get('validations.isValid')
    if (s = @get('currentCosigner'))
      s.get('isValid')
    else
      true
  ).property('validations.isValid', 'currentCosigner', 'currentCosigner.isValid')


  feeEstimate: (->
    @get('info').estimateFees(@get('totalSignatures'), @get('minSignatures'), @get('withServer'))
  ).property('withServer', 'totalSignatures', 'minSignatures')

  canDelete: (->
    (@get('cosignersCnt') > 1)
  ).property('cosignersCnt')

  setup: ( ->

    @set 'cosigners', A()
    cosigner = @createSimpleModel('account-cosigner', name: null)
    @get('cosigners').pushObject(cosigner)

    @setProperties(
      currentCosigner: cosigner
      masterName: @get('i18n').t('account.cosigners.you')
    )

  ).on('init')


  focusInput: ( ->
    scheduleOnce('afterRender', this, ->
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
      if @get('validations.isValid')
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
          set(cosigner, 'mandatory', true )
        else if @get('masterMandatory')
          @set('masterMandatory', false)
          set(cosigner, 'mandatory', true )
      else
        set(cosigner, 'mandatory', state)

    setMasterMandatory: (state) ->
      if state && (@get('mandatoryCnt') >= @get('maxMandatory'))
        if (c = @get('mandatoryCosigners').get('firstObject'))
          c.set('mandatory', false)
          @set('masterMandatory', true)
      else
        @set('masterMandatory', state)

)

export default CollectCosigners
