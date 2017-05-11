`import Ember from 'ember'`

StreamCounter = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  stream: Ember.inject.service('cm-stream')
  wallet: Ember.inject.service('cm-wallet')

  tagName: ''

  account: null

  mystream: ( ->
    @get('account.stream')  || @get('wallet.stream')
  ).property('account')

  urgent:  Ember.computed.alias('mystream.urgentCurrent.length')
  urgentNewer: Ember.computed.alias('mystream.urgentNewer.length')
  newer: Ember.computed.alias('mystream.newer.length')

  property: 'urgent'

  value: ( ->
    @get(p) if p = @get('property')
  ).property('urgent', 'urgentNewer', 'newer', 'property')

)

`export default StreamCounter`
