`import Ember from 'ember'`
`import Configuration from 'melis-cm-svcs/utils/configuration'`
`import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'`
`import BackButton from '../../mixins/backbutton-support'`
`import CMCore from 'npm:melis-api-js'`
`import { task, taskGroup } from 'ember-concurrency'`

C = CMCore.C

ImportWizard = Ember.Component.extend(AsWizard, BackButton,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')

  step: 1
  completeOn: 3

  apiOps: taskGroup().drop()

  closeWallet: task( ->
    return unless @get('cm.currentWallet')

    Ember.Logger.warn "Wallet is already open during enroll"
    try
      yield @get('cm').walletClose()
    catch err
      Ember.Logger.error "failed closing wallet: ", err
  )

  importWallet: task((pin) ->
    mnemonic = @get('importMnemonic')?.toLowerCase()
    passphrase = @get('importPassphrase')

    yield @get('closeWallet').perform()

    try
      wallet = yield @get('cm').importWallet(pin, mnemonic, passphrase)
      @set('credentials.backupConfirmed', true)
    catch err
      if err.ex == 'CmLoginWrongSignatureException'
        @set('importFailedCreds', err.msg)
      else
        @set('importFailed', err.msg)

  ).group('apiOps')

  setup: (->
    if !@get('credentials.validCredentials')
      @markCompleted(1, 2)
  ).on('willInsertElement')

  actions:
    confirmImport: ->
      @markCompleted(1, 2)

    doneImportMnemo: (mnemonic, passphrase)->
      @markCompleted(2, 3)
      @setProperties
        importMnemonic: mnemonic
        importPassphrase: passphrase

    doneSetPIN: (pin)->
      @markCompleted(3)
      @get('importWallet').perform(pin)

    resetImport: ->
      @clearCompleted()
      @setProperties
        importPassphrase: null
        step: 2

)


`export default ImportWizard`
