`import Ember from 'ember'`
`import Configuration from 'melis-cm-svcs/utils/configuration'`
`import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'`
`import BackButton from '../../mixins/backbutton-support'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { parseURI } from '../../utils/uris'`

Validations = buildValidations(
  passphrase: [
    validator('presence', true)
    validator('length', min: 8, max: 32)
  ]
)

BACKUP_SCHEME = 'melis+seed'

RecoverWizard = Ember.Component.extend(AsWizard, Validations, ValidationsHelper, BackButton,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')
  scanner: Ember.inject.service('scanner-provider')

  importError: null
  wrongSignature: null

  importData: null
  rawGenerator: null
  generator: null
  passphrase: null

  apiOps: taskGroup().drop()

  step: 1
  stepBack: true

  completeOn: 4

  backupImport: task((generator, passphrase, pin) ->

    cm = @get('cm')
    @set('importError', null)

    try
      res = yield cm.importWalletFromGen(pin, generator, passphrase)
    catch e
      if e.ex == 'CmLoginWrongSignatureException'
        @set 'wrongSignature', true
      else
        Ember.Logger.error "Error in recover: ", e
        @set('importError', e.msg)
  ).group('apiOps')


  parseData: (data) ->
    @set 'importError', null
    if data && (data.charAt(0) == '{')
      ## trying to pair

    else
      uri = parseURI(data)
      if uri.scheme == BACKUP_SCHEME
        @validateGenerator(uri.address)
      else
        Ember.Logger.error 'Invalid scan'
        @set 'importError', 'Invalid Scan'
        # not a valid scan


  validateGenerator: (data) ->
    if(res = @get('credentials').isGeneratorValid(data))
      @set 'generator', data
      @markCompleted(2, 3)
      unless res.encrypted
        @set 'plaintext', true
        @markCompleted(3, 4)
    else
      Ember.Logger.error 'Invalid Generator'
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
      @markCompleted(3, 4)

    doneInputPin: (pin) ->
      @markCompleted(4)
      @get('backupImport').perform(@get('generator'), @get('passphrase'), pin)

)


`export default RecoverWizard`
