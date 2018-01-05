`import Ember from 'ember'`

formatUnitLimit = Ember.Helper.extend(
  coinsvc: Ember.inject.service('cm-coin')
  i18n: Ember.inject.service()
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
        @get('coinsvc').formatUnit(account, amount, Ember.copy(options))
      catch
        '---'


  hasChanged: (-> @recompute()).observes('account.subunit')
)

`export default formatUnitLimit`


