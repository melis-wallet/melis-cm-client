`import Ember from 'ember'`
`import formatBtc from 'ember-cm-js/utils/format-btc'`

BitcoinTicker = Ember.Component.extend(

  ticker: Ember.inject.service('cm-ticker')

)

`export default BitcoinTicker`
