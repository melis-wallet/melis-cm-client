import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

MainDashboardController = Controller.extend(

  media: service('responsive-media')
  account: alias('cm.currentAccount')
)

export default MainDashboardController