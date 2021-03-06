import Component from '@ember/component'
import { inject as service } from '@ember/service'

import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import BackButton from '../../mixins/backbutton-support'
import { validator, buildValidations } from 'ember-cp-validations'
import { task, taskGroup } from 'ember-concurrency'
import { parseURI } from '../../utils/uris'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  passphrase: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
  ]
)

BACKUP_SCHEME = 'melis+seed'

RecoverWizard = Component.extend(AsWizard, Validations, BackButton,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  scanner: service('scanner-provider')

  importError: null
  wrongSignature: null
  tryingToPair: false

  importData: null
  rawGenerator: null
  generator: null
  passphrase: null

  apiOps: taskGroup().drop()

  step: 1
  stepBack: true

  completeOn: 4


  disableInput: ( ->
    @get('apiOps.isRunning')
  ).property('apiOps.isRunning')

  changedInput: ( ->

    @setProperties
      tryingToPair: false
      validationFailed: false
      importFailed: false
      importError: null
      wrongSignature: null
  ).observes('passphrase', 'generator')

  backupImport: task((generator, passphrase, pin) ->

    cm = @get('cm')
    @set('importError', null)

    try
      res = yield cm.importWalletFromGen(pin, generator, passphrase)
    catch e
      if e.ex == 'CmLoginWrongSignatureException'
        @set 'wrongSignature', true
      else
        Logger.error "Error in recover: ", e
        @set('importError', e.msg)
  ).group('apiOps')


  validateOpen: task( (generator, passphrase) ->

    @setProperties
      importFailed: null
      validationFailed: null
    try
      yield @get('cm').validateGenerator(generator, passphrase)
      @markCompleted(3, 4)

    catch err
      Logger.error('[recover]', err)
      if err.ex == 'CmLoginWrongSignatureException'
        @set('validationFailed', err.msg)
      else
        @set('importFailed', err.msg)
      false
  ).group('apiOps')

  parseData: (data) ->
    @set 'importError', null
    if data && (data.charAt(0) == '{')
      @set('tryingToPair', true)

    else
      uri = parseURI(data)
      if uri.scheme == BACKUP_SCHEME
        @validateParsedData(uri.address)
      else
        Logger.error 'Invalid scan'
        @set 'importError', 'Invalid Scan'
        # not a valid scan


  validateParsedData: (data) ->
    if(res = @get('credentials').isGeneratorValid(data))
      @set 'generator', data
      @markCompleted(2, 3)
      unless res.encrypted
        @set 'plaintext', true
        @markCompleted(3, 4)
    else
      Logger.error 'Invalid Generator'
      @set 'importError', 'Invalid Generator'


  setup: (->
    if !@get('credentials.validCredentials')
      @markCompleted(1, 2)
  ).on('willInsertElement')


  actions:
    confirmImport: ->
      @markCompleted(1, 2)

    restart: ->
      @clearCompleted()
      @setProperties(
        importData:  null
        pin: null
        passphrase: null
        importError:  null
        wrongSignature: null
        step: 2
      )

    openScanner: ->
      @get('scanner').independentScan().then((res) =>
        if res && res.data
          @parseData(res.data.trim())
      )

    importFromData: ->
      if data = @get('importData')
        @parseData(data)

    doneInputPass:  ->
      @get('validateOpen').perform(@get('generator'), @get('passphrase'))

    doneInputPin: (pin) ->
      @markCompleted(4)
      @get('backupImport').perform(@get('generator'), @get('passphrase'), pin)

)

export default RecoverWizard
