`import Ember from 'ember'`

AccountOpsController = Ember.Controller.extend(

  account: Ember.computed.alias('cm.currentAccount')
  media: Ember.inject.service('responsive-media')
)

`export default AccountOpsController`
