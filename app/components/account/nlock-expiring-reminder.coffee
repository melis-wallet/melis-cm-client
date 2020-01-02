import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, filter } from '@ember/object/computed'
import { get } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'

EXPIRE_THRESH = 6 #days

NlockReminder = Component.extend(

  tagName: null

  account: null
  unspents: alias('account.recoveryInfo.expiring')

  managing: false

  expiring: filter('unspents', (e) ->
    ex = get(e, 'timeExpire')
    (e.blockMature > 0) &&
    ((ex < moment().add(EXPIRE_THRESH, 'days').valueOf()) if ex)
  )

  firstExpiring: alias('expiring.firstObject')

  actions:
    toggleManaging: ->
      @toggleProperty('managing')

)

export default NlockReminder