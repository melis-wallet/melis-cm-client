`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import ModalAlerts from '../../mixins/modal-alerts'`
`import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'`


MainWalletController = Ember.Controller.extend(ModalAlerts,

  credentials: Ember.inject.service('cm-credentials')
  coinsvc: Ember.inject.service('cm-coin')
  aa: Ember.inject.service('aa-provider')
  mm: Ember.inject.service('modals-manager')

  queryParams: ['new-account', 'tab']
  tab: null

  'new-account': false

  account: Ember.computed.alias('cm.currentAccount')
  modalManager: Ember.inject.service('modals-manager')

  apiOps: taskGroup().drop()

  credentialsBackup: false
  credentialsBackupCk: false
  paring: false

  openAccWizard: ( ->
    if @get('new-account')
      Ember.run.scheduleOnce 'afterRender', this, ->
        @get('modalManager').showModal('new-acct-wizard')
        @set('new-account', false)
  ).observes('new-account').on('init')

  dangerEnabled: false


  deleteAllDevices: task( ->
    api = @get('cm.api')

    op = (tfa) =>
      api.devicesDeleteAll(@get('credentials.deviceId'))
    try
      ok = yield @showModalAlert(
        type: 'warning'
        title: 'wallet.devices.list.wdelete.title'
        caption: 'wallet.devices.list.wdelete.caption'
      )
      return unless ok == 'ok'

      res = yield @get('aa').tfaOrLocalPin(op)
    catch e
      @set 'error', e.msg
      Ember.Logger.error "Dev delete error: ", e
  ).group('apiOps')

  deleteCredentials: task( ->
    { cm, credentials } = @getProperties('cm', 'credentials')

    try

      ok = yield @showModalAlert(
        type: 'warning'
        title: 'wallet.maint.wdelete.title'
        caption: 'wallet.maint.wdelete.caption'
      )
      return unless ok == 'ok'

      yield cm.walletClose()
      credentials.reset()

      @get('cm').resetApp()
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')


  actions:

    reviewLicense: ->
      @get('mm').showModal('license')

    startPairing: ->
      @set 'pairing', true
      false

    donePairing: ->
      @set 'pairing', false

    changeLocale: (locl)->
      @set('cm.locale', locl)

    changeBtcUnit: (btcunit)->
      @set('cm.btcUnit', Ember.get(btcunit, 'id'))

    newAcctWizard: ->
      @get('modalManager').showModal('new-acct-wizard')

    doAcctJoinIn: ->
      @set 'acctJoinIn', true
      false

    doneAcctJoinIn: ->
      @set 'acctJoinIn', false

    doCredBackup: ->
      @set 'credentialsBackup', true
      false

    doneCredBackup: ->
      @set 'credentialsBackup', false



    doCredBackupCk: ->
      @set 'credentialsBackupCk', true
      false

    doneCredBackupCk: ->
      @set 'credentialsBackupCk', false


    doneNewAccount: (acct) ->
      Ember.run.scheduleOnce 'afterRender', this, ->
        @transitionToRoute('main.account.summary', Ember.get(acct, 'pubId'))


    toggleDanger: ->
      @toggleProperty('dangerEnabled')
      false

    deleteCredentials: ->
      @get('deleteCredentials').perform()


    deleteAllDevices: ->
      @get('deleteAllDevices').perform()




)

`export default MainWalletController`
