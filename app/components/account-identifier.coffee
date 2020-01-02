import Component from '@ember/component'
import { alias } from '@ember/object/computed'

AccountIdentifier = Component.extend(

  tagName: null

  account: null
  icon: alias('account.cmo.meta.icon')


)

export default AccountIdentifier
