import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, sort } from '@ember/object/computed'
import { get, set } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'
import ModalAlerts from '../../mixins/modal-alerts'

import Logger from 'melis-cm-svcs/utils/logger'


AccountsManagement = Component.extend(ModalAlerts,

  cm: service('cm-session')
  aa: service('aa-provider')
  i18n: service()

  accountsSorting: ['pos:asc', 'name:asc'],
  accounts: sort('cm.accounts', 'accountsSorting')

  apiOps: taskGroup().enqueue()

  setSecure: task((acct) ->
    api = @get('cm.api')

    if acct
      op = (tfa) ->
          api.accountUpdate(acct.get('cmo'), hidden: true, tfa: tfa.payload)

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

        res = yield @get('aa').tfaOrLocalPin(op)
        if (pubId = get(res, 'account.pubId'))
          @get('cm').accountSecure(pubId, get(res, 'account.hidden'))

      catch error
        Logger.error "Error: ", error

  ).group('apiOps')


  unsetSecure: task((acct) ->
    api = @get('cm.api')

    if acct
      op = (tfa) ->
          api.accountUpdate(acct.get('cmo'), hidden: false, tfa: tfa.payload)
      try
        res = yield @get('aa').tfaOrLocalPin(op)
        if (pubId = get(res, 'account.pubId'))
          @get('cm').accountSecure(pubId, get(res, 'account.hidden'))
      catch error
        Logger.error "Error: ", error
  ).group('apiOps')

  actions:
    toggleInvisible: (acct) ->
      i = acct.get('invisible')
      if i
        acct.set('invisible', false)
      else if @get('cm.accounts').filterBy('invisible', false).get('length') > 1
        acct.set('invisible', true)


    setSecure: (acct) ->
      @get('setSecure').perform(acct)


    unsetSecure: (acct) ->
      @get('unsetSecure').perform(acct)

)

export default AccountsManagement