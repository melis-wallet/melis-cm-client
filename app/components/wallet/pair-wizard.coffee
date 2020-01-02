import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import BackButton from '../../mixins/backbutton-support'
import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  pin: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

PairWizard = Component.extend(AsWizard, Validations, ValidationsHelper, BackButton,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  scanner: service('scanner-provider')

  scanError: null
  importError: null
  importData: null
  pin: null

  apiOps: taskGroup().drop()

  step: 1
  stepBack: true

  completeOn: 4

  showPinForm: ( ->
    err = @get('importError')
    (!err || (err == 'WrongPin'))
  ).property('importError')

  pairImport: task((data, pin) ->

    cm = @get('cm')
    @set('importError', null)

    try
      res = yield cm.importForPairing(data, pin)
      @markCompleted(4)
      @sendAction('on-pair-complete')
    catch e
      @set('importError', e.ex)
  ).group('apiOps')


  scanCode: task( ->
    try
      res = yield @get('scanner').independentScan()
      if res && res.data
        if @get('credentials').validatePairingData(res.data)
          @set('importData', res.data)
          @markCompleted(3, 4)
        else
          @set 'scanError', true
    catch e
      unless e == 'closed'
        @set 'scanError', true
        Logger.error "error: ", e
  ).drop()

  setup: (->
    if !@get('credentials.validCredentials')
      @markCompleted(1, 2)
  ).on('willInsertElement')

  actions:


    confirmImport: ->
      @markCompleted(1, 2)

    doneSource: ->
      @markCompleted(2, 3)

    restart: ->
      @clearCompleted()
      @setProperties
        importData: null
        pin: null
        importError: null
        step: 2


    openScanner: ->
      @get('scanCode').perform()


    importFromData: ->
      if data = @get('importData')
        @markCompleted(3, 4)


    doneInputPin:  ->
      @get('pairImport').perform(@get('importData'), @get('pin'))

)

export default PairWizard
