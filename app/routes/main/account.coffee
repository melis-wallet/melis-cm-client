import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'
import RSVP from 'rsvp'

import Logger from 'melis-cm-svcs/utils/logger'

MainAccountRoute = Route.extend(

  cm: service('cm-session')
  credentials: service('cm-credentials')

  model: (params) ->

    cm = @get('cm')
    cm.waitForReady().then( =>
      curr_acct_id = cm.get('currentAccount.pubId')

      if curr_acct_id != params.account_id

        Logger.info '++ Selecting Account: ', params.account_id

        if cm.selectAccount(params.account_id, true)
          false
        else
          Logger.error 'Non existent account: ', params.account_id
          @set('cm.currentAccount', null)
          #RSVP.reject "trying to select a non-existent account"


    )

  actions:
    need_signin: ->
      @transitionTo('wallet.sign-in')

    #error: (error, transition) ->
    #  console.error "ERROR TRANS"



)

export default MainAccountRoute
