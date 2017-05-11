`import Ember from 'ember'`

formatBtcLimit = Ember.Helper.extend(
  currencySvc:  Ember.inject.service('cm-currency')
  i18n: Ember.inject.service()

  compute: (params, options) ->

    amount = params[0]
    if amount == -1
      @get('i18n').t('account.limits.none')
    else if amount == 0
      @get('i18n').t('account.limits.always')
    else
      @get('currencySvc').formatBtc(amount, Ember.copy(options))

  dividerHasChanged: (-> @recompute()).observes('currencySvc.btcDivider')
)

`export default formatBtcLimit`


