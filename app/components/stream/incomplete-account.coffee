`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

IncompleteAccount = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  apiOps: taskGroup().drop()

  account: null

  cosigners: Ember.computed.alias('account.info.cosigners')
  acctInfo: Ember.inject.service('cm-account-info')

  classNames: ['row', 'animated', 'fadeIn']


  deleteAcct: task( ->
    cm = @get('cm')

    if account = @get('account')
      try
        yield cm.accountDelete(account)


      catch error
        Ember.Logger.error 'Error: ', error

  ).group('apiOps')


  actions:
    deleteAcct: ->
      @get('deleteAcct').perform()

)


`export default IncompleteAccount`
