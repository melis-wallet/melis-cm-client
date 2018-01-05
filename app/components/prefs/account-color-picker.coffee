import Ember from 'ember'
import { task, timeout } from 'ember-concurrency'
import Account from 'melis-cm-svcs/models/account'


ColorPicker = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  account: null

  colors: Account.colors
  selected: Ember.computed.alias('account.color')


  actions:
    colorChanged: (value) ->
      @sendAction('on-change', @get('account'), value)

)

export default ColorPicker
