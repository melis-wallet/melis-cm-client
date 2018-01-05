import Ember from 'ember'

AccountIdentifier = Ember.Component.extend(

  tagName: null

  account: null
  icon: Ember.computed.alias('account.cmo.meta.icon')


)

export default AccountIdentifier
