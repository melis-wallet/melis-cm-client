`import Ember from 'ember'`

LinkToExplorer = Ember.Component.extend(

  tagName: 'span'

  cm: Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')

  account: null

  hash: null

  url: ( ->
    if account = @get('account')
      @get('coinsvc').urlToExplorer(account, @get('hash'))
  ).property('hash', 'account', 'accoint.coin.currentExplorer')

)

`export default LinkToExplorer`
