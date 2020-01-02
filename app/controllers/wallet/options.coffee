import Controller from '@ember/controller'
import { inject as service } from '@ember/service'

OptionsController = Controller.extend(
  credentials: service('cm-credentials')

)

export default OptionsController
