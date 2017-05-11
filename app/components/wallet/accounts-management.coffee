`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import ModalAlerts from '../../mixins/modal-alerts'`


AccountsManagement = Ember.Component.extend(ModalAlerts,

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')
  i18n: Ember.inject.service()

  accountsSorting: ['name:asc'],
  accounts: Ember.computed.sort('cm.accounts', 'accountsSorting')

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
      catch error
        Ember.Logger.error "Error: ", error

  ).group('apiOps')


  unsetSecure: task((acct) ->
    api = @get('cm.api')

    if acct
      op = (tfa) ->
          api.accountUpdate(acct.get('cmo'), hidden: false, tfa: tfa.payload)
      try
        res = yield @get('aa').tfaOrLocalPin(op)
      catch error
        Ember.Logger.error "Error: ", error
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

`export default AccountsManagement`