import Component from '@ember/component'
import { inject as service } from '@ember/service'

import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import BackButton from '../../mixins/backbutton-support'
import CMCore from 'npm:melis-api-js'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C


ImportWizard = Component.extend(AsWizard, BackButton,

  cm: service('cm-session')
  credentials: service('cm-credentials')

  step: 1
  completeOn: 3

  apiOps: taskGroup().drop()

  importFailed: null
  importFailedCreds: null

  importMnemonic: null
  importPassphrase: null

  disableInput: ( ->
    @get('apiOps.isRunning')
  ).property('importMnemonic', 'apiOps.isRunning')

  closeWallet: task( ->
    return unless @get('cm.currentWallet')

    Logger.warn "Wallet is already open during enroll"
    try
      yield @get('cm').walletClose()
    catch err
      Logger.error "failed closing wallet: ", err
  )

  importWallet: task((pin) ->
    mnemonic = @get('importMnemonic')?.toLowerCase()
    passphrase = @get('importPassphrase')
    @setProperties
      importFailedCreds: null
      importFailed: null

    yield @get('closeWallet').perform()

    try
      wallet = yield @get('cm').importWallet(pin, mnemonic, passphrase)
    catch err
      if err.ex == 'CmLoginWrongSignatureException'
        @set('importFailedCreds', err.msg)
      else
        @set('importFailed', err.msg)

  ).group('apiOps')

  validateCredentials: task( (mnemonic, passphrase) ->

    mnemonic = mnemonic?.toLowerCase()
    @setProperties
      importFailed: null
      validationFailed: null
    try
      yield @get('cm').validateCredentials(mnemonic, passphrase)
      @markCompleted(2, 3)
      @setProperties
        importMnemonic: mnemonic
        importPassphrase: passphrase
    catch err
      Logger.error('[import]', err)
      if err.ex == 'CmLoginWrongSignatureException'
        @set('validationFailed', err.msg)
      else
        @set('importFailed', err.msg)
      false

  ).group('apiOps')

  setup: (->
    if !@get('credentials.validCredentials')
      @markCompleted(1, 2)
  ).on('willInsertElement')

  actions:
    confirmImport: ->
      @markCompleted(1, 2)

    doneImportMnemo: (mnemonic, passphrase)->
      @get('validateCredentials').perform(mnemonic, passphrase)


    doneSetPIN: (pin)->
      @markCompleted(3)
      @get('importWallet').perform(pin)

    resetImport: ->
      @clearCompleted()
      @setProperties
        importMnemonic: null
        importPassphrase: null
        step: 2
        importFailedCreds: null
        importFailed: null
        validationFailed: null

)

export default ImportWizard
