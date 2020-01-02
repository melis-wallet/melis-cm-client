import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { computed } from '@ember/object'

import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'

ExportWizard = Component.extend(AsWizard,

  cm: service('cm-session')
  credentials: service('cm-credentials')

  app_state: service('app-state')

  step: 1
  completeOn: 4

  showQC: false
  locale: null
  exportedGenerator: null

  encryptedBack: false
  passphrase: null

  exportedGeneratorQR: ( ->
    if gen = @get('exportedGenerator')
      'melis+seed:' + gen
  ).property('exportedGenerator')

  exportedMnemonic: ( ->

    if gen = @get('exportedGenerator')
      { credentials, locale } = @getProperties('credentials', 'locale')
      credentials.generateMnemonic(gen, locale)
  ).property('exportedGenerator', 'locale')

  exportMnemonic: ->
    {credentials, devicePass, passphrase} = @getProperties('credentials', 'devicePass', 'passphrase')
    res = credentials.backupGenerator(devicePass, passphrase)

    @get('cm').updateBackupState(backupConfirmed: (moment().unix() * 1000))
    @set('exportedGenerator', res.entropy)


  setup: ( ->
    @set('locale', @get('cm.locale'))
    @get('exportedGeneratorQR')
  ).on('init')

  actions:

    copyExportData: ->
      @set('app_state.exportedGeneratorQR', @get('exportedGeneratorQR'))
      @set('app_state.exportedMnemonic', @get('exportedMnemonic'))
      @sendAction('on-wizard-complete')

    changeLocale: (locl) ->
      @set('locale', locl)

    failedPIN: ->
      @clearCompleted()
      @set('passphrase', null)

    doneEnterPIN: (pin, devicePass) ->
      # if pin is entered, the whole wizard is invalid
      @clearCompleted()
      @setProperties(
        pin: pin
        devicePass: devicePass
        passphrase: null
      )
      @markCompleted(1, 2)

    doneSetPhrase: (passphrase) ->
      @set('passphrase', passphrase)
      @markCompleted(2, 3)
      @exportMnemonic()

    doneSetNoPhrase: ->
      @set('passphrase', null)
      @markCompleted(2, 3)
      @exportMnemonic()

    toggleQC: ->
      @toggleProperty('showQC')


    doneQC: ->
      @markCompleted(3, 4)

    confirmBackup: ->
      @markCompleted(4)
)

export default ExportWizard
