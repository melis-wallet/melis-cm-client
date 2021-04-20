import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias, sort, empty } from '@ember/object/computed'
import { get, set } from '@ember/object'
import { A } from '@ember/array'

import { task, taskGroup } from 'ember-concurrency'
import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'
import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import ModalAlerts from '../../../mixins/modal-alerts'

import Logger from 'melis-cm-svcs/utils/logger'
import config from '../../../config/environment'

DONATE_IMG_URI = 'https://www.melis.io/images/donate-%COIN-180x70.png'
DONATE_TEMPLATE = """
  <a href="%URL">
    <img src="%IMG" alt='melis donate'>
  </a>
"""

AccountIndexController = Controller.extend(Alertable, ModalAlerts,

  credentials: service('cm-credentials')
  aa: service('aa-provider')
  modalManager: service('modals-manager')
  accountInfo: service('cm-account-info')


  account: alias('cm.currentAccount')
  coin: alias('account.unit.symbol')

  apiOps: taskGroup().drop()

  donateImgUri: DONATE_IMG_URI
  recoveryUrls: A(config.APP.recoveryUrls)

  queryParams: ['tab', 'debug']
  tab: 'preferences'
  debug: false

  dangerEnabled: false
  xpubEnabled: false

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
    tmpl.replace('%URL', uri).replace('%IMG', DONATE_IMG_URI).replace('%COIN', @get('coin'))
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
    api = @get('cm.api')
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
      op = (tfa) ->
        api.accountUpdate(account.get('cmo'), hidden: true, tfa: tfa.payload)
      res = yield @get('aa').tfaOrLocalPin(op)
      if (pubId = get(res, 'account.pubId'))
        @get('cm').accountSecure(pubId, get(res, 'account.hidden'))      
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
  ).group('apiOps')

  accountUnSecure: task((account) ->
    api = @get('cm.api')
    try
      op = (tfa) ->
        api.accountUpdate(account.get('cmo'), hidden: false, tfa: tfa.payload)    
      res = yield @get('aa').tfaOrLocalPin(op)
      if (pubId = get(res, 'account.pubId'))
        @get('cm').accountSecure(pubId, get(res, 'account.hidden'))
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
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
      @transitionToRoute('main.account.dashboard', @get('cm.accounts.firstObject.pubId'))
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
  ).group('apiOps')


  changeAcctColor: task((account, color) ->
    try
      cmo = get(account, 'cmo')
      meta = mergedProperty(cmo, 'meta', color: color)
      yield @get('cm.api').accountUpdate(cmo, {meta: meta})
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
  ).group('apiOps')

  changeAcctIcon: task((account, icon) ->
    try
      cmo = get(account, 'cmo')
      meta = mergedProperty(cmo, 'meta', icon: icon)
      yield @get('cm.api').accountUpdate(cmo, {meta: meta})
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
  ).group('apiOps')


  changeAcctName: task((account, newname) ->
    try
      cmo = get(account, 'cmo')
      meta = mergedProperty(cmo, 'meta', name: newname)
      yield @get('cm.api').accountUpdate(cmo, {meta: meta})
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
  ).group('apiOps')

  deleteCredentials: task( ->
    { cm, credentials } = @getProperties('cm', 'credentials')

    try
      yield cm.walletClose()
      credentials.reset()

      @get('cm').resetApp()
    catch e
      @alertDanger(e.msg, true)
      Logger.error 'Error: ', e
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

    toggleXpub: ->
      @toggleProperty('xpubEnabled')
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

    changeAccountColor: (account, color) ->
      if account
        @get('changeAcctColor').perform(account, color)

    changeAccountIcon: (account, icon) ->
      if account
        @get('changeAcctIcon').perform(account, icon)

)

export default AccountIndexController
