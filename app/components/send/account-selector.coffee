import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { filter } from "@ember/object/computed"
import { get } from '@ember/object'

AccountSelector = Component.extend(

  cm: service('cm-session')
  exclude: null

  # same coin as this account
  coin: null


  accounts: filter('cm.accounts', ((acc, idx) ->
    return false if (pubId = @get('exclude.pubId')) && (get(acc, 'pubId') == pubId)

    if (coin = @get('coin'))
      get(acc, 'coin') == coin
    else
      true
  ))

  selected: null

  actions:
    changedAccount: (account) ->
      @sendAction 'on-account-change', account

)

export default AccountSelector


