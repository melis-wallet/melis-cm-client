import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias, sort } from '@ember/object/computed'

MainDashboardController = Controller.extend(

  media: service('responsive-media')
  coinsvc: service('cm-coin')

  accountsSorting: ['cmo.cd:asc'],
  accounts: sort('cm.visibleAccts', 'accountsSorting')

)

export default MainDashboardController
