`import Ember from 'ember'`


MainAccountRoute = Ember.Route.extend(

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')

  model: (params) ->

    cm = @get('cm')
    cm.waitForReady().then( =>
      curr_acct_id = cm.get('currentAccount.pubId')

      if curr_acct_id != params.account_id

        Ember.Logger.info '++ Selecting Account: ', params.account_id
        cm.selectAccount(params.account_id, true)
        false
    )

  actions:
    need_signin: ->
      @transitionTo('wallet.sign-in')


)

`export default MainAccountRoute`
