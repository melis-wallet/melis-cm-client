import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

StreamCounter = Component.extend(

  cm: service('cm-session')
  stream: service('cm-stream')
  wallet: service('cm-wallet')

  tagName: ''

  account: null

  mystream: ( ->
    @get('account.stream')  || @get('wallet.stream')
  ).property('account')

  urgent: alias('mystream.urgentCurrent.length')
  urgentNewer: alias('mystream.urgentNewer.length')
  newer: alias('mystream.newer.length')

  property: 'urgent'

  value: ( ->
    @get(p) if p = @get('property')
  ).property('urgent', 'urgentNewer', 'newer', 'property')

)

export default StreamCounter
