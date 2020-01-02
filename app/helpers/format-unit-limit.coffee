import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'
import { copy } from 'ember-copy'


formatUnitLimit = Helper.extend(
  coinsvc: service('cm-coin')
  i18n: service()
  account: null

  compute: (params, options) ->

    amount = params[0]
    account = @set('account', options.account)

    if amount == -1
      @get('i18n').t('account.limits.none')
    else if amount == 0
      @get('i18n').t('account.limits.always')
    else
      try
        @get('coinsvc').formatUnit(account, amount, copy(options))
      catch
        '---'

  hasChanged: (-> @recompute()).observes('account.subunit')
)

export default formatUnitLimit


