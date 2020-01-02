import Component from '@ember/component'
import { inject as service } from '@ember/service'

import { task, timeout } from 'ember-concurrency'
import Account from 'melis-cm-svcs/models/account'


IconPicker = Component.extend(

  cm: service('cm-session')

  account: null

  icons: Account.icons
  selected: ( ->
    @get('account.cmo.meta.icon') || 'no-icon'
  ).property('account.cmo.meta.icon')


  actions:
    iconChanged: (value) ->
      value = null if (value == 'no-icon')
      @sendAction('on-change', @get('account'), value)

)

export default IconPicker
