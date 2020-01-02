import Component from '@ember/component'
import { inject as service } from '@ember/service'

LinkToExplorer = Component.extend(

  tagName: 'span'

  cm: service('cm-session')
  coinsvc: service('cm-coin')

  account: null

  hash: null

  url: ( ->
    if account = @get('account')
      @get('coinsvc').urlToExplorer(account, @get('hash'))
  ).property('hash', 'account', 'accoint.coin.currentExplorer')

)

export default LinkToExplorer
