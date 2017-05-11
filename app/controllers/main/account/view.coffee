`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`
`import ModalAlerts from '../../../mixins/modal-alerts'`

DONATE_IMG_URI = 'https://www.melis.io/images/donate-180x70.png'
DONATE_TEMPLATE = """
  <a href="%URL">
    <img src="%IMG" alt='melis donate'>
  </a>
"""

AccountIndexController = Ember.Controller.extend(Alertable, ModalAlerts,

  credentials: Ember.inject.service('cm-credentials')
  aa: Ember.inject.service('aa-provider')


  account: Ember.computed.alias('cm.currentAccount')
  modalManager: Ember.inject.service('modals-manager')

  accountInfo: Ember.inject.service('cm-account-info')

  apiOps: taskGroup().drop()


  donateImgUri: DONATE_IMG_URI

  queryParams: ['tab']
  tab: 'preferences'

  dangerEnabled: false

  showCredWarning: ( ->
    !@get('credentials.backupConfirmed') && !@get('credentialsBackup')
  ).property('credentialsBackup', 'credentials.backupConfirmed')

  currencies: (->
    @get('cm.currencies').map( (e) ->
      return {id: e, text: e}
    )
  ).property('cm.currencies.[]')

  encodedUniqueId: ( ->
    encodeURIComponent(@get('account.uniqueId'))
  ).property('account.uniqueId')


  donateCode: ( ->
    id = @get('encodedUniqueId')
    uri = @get('cm').webUrlFor('public.payto', id)

    tmpl = DONATE_TEMPLATE
    tmpl.replace('%URL', uri).replace('%IMG', DONATE_IMG_URI)
  ).property('encodedUniqueId')


  accountFees: ( ->
    @get('accountInfo').estimateFeesFor(@get('account'))
  ).property('account')


  resetState: ( ->
    @closeAllAlerts()
    @set('dangerEnabled', false)
  ).observes('account')

  setup: (->
    @get('accountInfo')
  ).on('init')


  accountSecure: task((account) ->
    try
      if @get('cm.currentWallet.info.isPrimaryDevice')
        prompt =
          type: 'info'
          title: 'account.maint.secure.prompt.title'
          caption: 'account.maint.secure.prompt.caption'
      else
        prompt =
          type: 'warning'
          title: 'account.maint.secure.npprompt.title'
          caption: 'account.maint.secure.npprompt.caption'

      ok = yield @showModalAlert(prompt)
      return unless ok == 'ok'

      yield @get('cm.api').accountUpdate(account.get('cmo'), hidden: true)
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')

  accountUnSecure: task((account) ->
    try
      yield @get('cm.api').accountUpdate(account.get('cmo'), hidden: false)
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')


  deleteAcct:  task((account) ->
    cm = @get('cm')

    try

      ok = yield @showModalAlert(
        type: 'warning'
        title: 'account.maint.delete.w.title'
        caption: 'account.maint.delete.w.caption'
      )
      return unless ok == 'ok'
      yield cm.accountDelete(account)
      @transitionToRoute('main.account.dashboard', @get('cm.accounts.firstObject.num'))
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')

  changeAcctName: task((account, newname) ->

    try
      cmo = Ember.get(account, 'cmo')
      meta = mergedProperty(cmo, 'meta', name: newname)
      yield @get('cm.api').accountUpdate(cmo, {meta: meta})
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')


  deleteCredentials: task((account, newname) ->
    { cm, currentWallet, credentials } = @getProperties('cm', 'currentWallet', 'credentials')

    try
      yield cm.walletClose()
      credentials.reset()
      window.location.reload()
    catch e
      @alertDanger(e.msg, true)
      Ember.Logger.error 'Error: ', e
  ).group('apiOps')


  actions:

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


    toggleDanger: ->
      @toggleProperty('dangerEnabled')
      false

    deleteCredentials: ->
      @get('deleteCredentials').perform()

    toggleAcctInvis: (account) ->
      account.toggleProperty('invisible') if account
      false

    accountSecure: (account) ->
      @get('accountSecure').perform(account) if account

    accountUnSecure: (account) ->
      @get('accountUnSecure').perform(account) if account

    deleteCurrentAcct: ->
      if (account = @get('account'))
        @get('deleteAcct').perform(account)

    changeAccountName: (newname) ->
      if (account = @get('account'))
        @get('changeAcctName').perform(account, newname)
)

`export default AccountIndexController`
