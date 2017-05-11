`import Ember from 'ember'`


BackupReminder = Ember.Component.extend(

  tagName: null
  creds: Ember.inject.service('cm-credentials')
  cm: Ember.inject.service('cm-session')


  showBackupWizard: false
  showBackupChecker: false

  showCredWarning: Ember.computed.not('creds.backupConfirmed')

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
      @set 'creds.backupChecked', moment().unix()

)


`export default BackupReminder`