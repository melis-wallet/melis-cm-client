`import Ember from 'ember'`

BitcoinTicker = Ember.Component.extend(

  currencySvc: Ember.inject.service('cm-currency')

  compact: false

)

`export default BitcoinTicker`
