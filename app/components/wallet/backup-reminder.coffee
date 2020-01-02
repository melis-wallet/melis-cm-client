import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { computed } from '@ember/object'


BackupReminder = Component.extend(

  tagName: null
  creds: service('cm-credentials')
  cm: service('cm-session')


  showBackupWizard: false
  showBackupChecker: false

  showCredWarning: computed.not('creds.backupConfirmed')

  showBackupNagger: ( ->
    (@get('creds.backupConfirmed') && !@get('creds.backupChecked') && @get('cm.currentAccount.amSummary'))
  ).property('creds,backupConfirmed', 'creds.backupChecked', 'cm.currentAccount.amSummary')

  actions:

    doCredBackup: ->
      @set 'showBackupWizard', true
      false

    doneCredBackup: ->
      @set 'showBackupWizard', false

    doBackupCheck: ->
      @set 'showBackupChecker', true

    doneBackupCheck: ->
      @set 'showBackupChecker', false

    validBackupCheck: ->
      @get('cm').updateBackupState(backupChecked: (moment().unix() * 1000))

)

export default BackupReminder