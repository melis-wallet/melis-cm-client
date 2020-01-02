import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

AccountOpsController = Controller.extend(

  media: service('responsive-media')
  account: alias('cm.currentAccount')
)

export default AccountOpsController
