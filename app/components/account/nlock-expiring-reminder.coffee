`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import { task, taskGroup } from 'ember-concurrency'`

EXPIRE_THRESH = 6 #days

NlockReminder = Ember.Component.extend(

  tagName: null

  account: null
  unspents: Ember.computed.alias('account.recoveryInfo.expiring')

  managing: false

  expiring: Ember.computed.filter('unspents', (e) ->
    ex = Ember.get(e, 'timeExpire')
    (e.blockMature > 0) &&
    ((ex < moment().add(EXPIRE_THRESH, 'days').valueOf()) if ex)
  )

  firstExpiring: Ember.computed.alias('expiring.firstObject')

  actions:
    toggleManaging: ->
      @toggleProperty('managing')

)
`export default NlockReminder`