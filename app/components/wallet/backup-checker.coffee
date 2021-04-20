import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias  } from '@ember/object/computed'
import { computed } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import { parseURI } from '../../utils/uris'
import { validator, buildValidations } from 'ember-cp-validations'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  passphrase: [
    validator('presence', presence: true, disabled: computed.not('model.encrypted'))
    validator('length', min: 8, max: 32, disabled: computed.not('model.encrypted'))
  ]
)

BACKUP_SCHEME = 'melis+seed'

BackupChecker = Component.extend(AsWizard, Validations, 
  cm: service('cm-session')
  credentials: service('cm-credentials')
  scanner: service('scanner-provider')
  i18n: service()

  pin: null

  failed: null
  importError: null

  step: 1
  completeOn: 4
  stepBack: true

  encrypted: false
  passphrase: null

  apiOps: taskGroup().drop()

  validateMnemonic: task((pin, mnemonic, passphrase) ->
    @set('failed', null)

    try
      res = yield @get('cm').validateMnemonic(pin, mnemonic, passphrase)
      if res
        @validOk()
      else
        Logger.debug 'Does not validate'
        @set 'failed',  @get('i18n').t('backup.ck.err.failed-backup')

    catch e
      Logger.error "Failed check: ", e
      @set 'failed',  @get('i18n').t('backup.ck.err.failed-check')
  )

  validOk: ->
    @markCompleted(3)
    @markCompleted(4)
    @sendAction('on-valid-backup')

  parseData: (data) ->
    @set 'importError', null
    if data && (data.charAt(0) == '{')
      ## user is trying to pair
      @set 'importError', @get('i18n').t('backup.ck.err.pair')
    else
      uri = parseURI(data)
      if uri.scheme == BACKUP_SCHEME
        @validateGenerator(uri.address)
      else
        Logger.error 'Invalid scan'
        @set 'importError', @get('i18n').t('backup.ck.err.invalid-scan')


  validateGenerator: (data) ->
    if(res = @get('credentials').isGeneratorValid(data))

      if res.encrypted
        @set 'encrypted', data
        @markCompleted(3, 4)
      else
        @set 'encrypted', null
        @get('checkGenerator').perform(data)

    else
      Logger.error 'Invalid Generator'
      @set 'importError',  @get('i18n').t('backup.ck.err.invalid-gen')


  validateEncrGen: ->
    { encrypted,
      passphrase } = @getProperties('encrypted', 'passphrase')

    @get('checkGenerator').perform(encrypted, passphrase)


  checkGenerator: task((gen, passphrase) ->
    @set('failed', null)

    pin = @get('pin')

    try
      res = yield @get('cm').validateBackup(pin, gen, passphrase)
      if res
        @validOk()
      else
        Logger.debug 'Does not validate'
        @set 'failed',  @get('i18n').t('backup.ck.err.failed-backup')

    catch e
      Logger.error "Failed check: ", e
  )


  acquireQR: task( ->
    @setProperties
      importError: null
      failed: null


    try
      res = yield @get('scanner').independentScan()
      if res && res.data
        @parseData(res.data.trim())
    catch e
      Logger.error('Scanner Error', e)
      @set 'importError',  @get('i18n').t('backup.ck.err.scanner')

  )

  actions:
    seenIntro: ->
      @markCompleted(1, 2)

    doneInputPin: (pin) ->
      @set('pin', pin)
      @markCompleted(2, 3)

    doneCollectMnemo: (mnemonic, passphrase) ->
      if (pin = @get('pin'))
        @get('validateMnemonic').perform(pin, mnemonic, passphrase)

    retryScan: ->
      @markNotCompleted(4)
      @setProperties
        step: 3
        importError: null
        failed: null
        encrypted: null
        passphrase: null

    acquireQR: ->
      @get('acquireQR').perform()

    submitPassphrase: ->
      @validateEncrGen()

    done: ->
      @sendAction('on-done')

)

export default BackupChecker