import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, timeout } from 'ember-concurrency'
import Account from 'melis-cm-svcs/models/account'


ColorPicker = Component.extend(

  cm: service('cm-session')

  account: null

  colors: Account.colors
  selected: alias('account.color')


  actions:
    colorChanged: (value) ->
      @sendAction('on-change', @get('account'), value)

)

export default ColorPicker
