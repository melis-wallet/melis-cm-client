`import Ember from 'ember'`


MainAccountRoute = Ember.Route.extend(

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')

  model: (params) ->

    cm = @get('cm')
    cm.waitForReady().then( =>
      curr_acct_num = cm.get('currentAccount.num')
      account_num = parseInt(params.account_num)

      if curr_acct_num != account_num

        Ember.Logger.info '++ Selecting Account: ', account_num
        cm.selectAccount(account_num, true)
        false
    )

  actions:
    need_signin: ->
      @transitionTo('wallet.sign-in')


)

`export default MainAccountRoute`
