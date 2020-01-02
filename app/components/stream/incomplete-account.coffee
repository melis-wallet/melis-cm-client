import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


IncompleteAccount = Component.extend(

  cm: service('cm-session')
  acctInfo: service('cm-account-info')

  apiOps: taskGroup().drop()

  account: null
  cosigners: alias('account.info.cosigners')

  classNames: ['row', 'animated', 'fadeIn']

  deleteAcct: task( ->
    cm = @get('cm')

    if account = @get('account')
      try
        yield cm.accountDelete(account)


      catch error
        Logger.error 'Error: ', error

  ).group('apiOps')

  actions:
    deleteAcct: ->
      @get('deleteAcct').perform()

)

export default IncompleteAccount
