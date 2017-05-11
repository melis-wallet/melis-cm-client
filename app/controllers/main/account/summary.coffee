`import Ember from 'ember'`

MainDashboardController = Ember.Controller.extend(

  media: Ember.inject.service('responsive-media')
  account: Ember.computed.alias('cm.currentAccount')

)

`export default MainDashboardController`
