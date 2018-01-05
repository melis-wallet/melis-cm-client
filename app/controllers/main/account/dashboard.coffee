`import Ember from 'ember'`

MainDashboardController = Ember.Controller.extend(

  media: Ember.inject.service('responsive-media')
  coinsvc: Ember.inject.service('cm-coin')

  accountsSorting: ['cmo.cd:asc'],
  accounts: Ember.computed.sort('cm.visibleAccts', 'accountsSorting')


)

`export default MainDashboardController`
