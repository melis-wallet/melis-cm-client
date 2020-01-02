import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


InfoExportController = Controller.extend(

  app_state: service('app-state')

  exportedGeneratorQR:  alias('app_state.exportedGeneratorQR')
  exportedMnemonic:  alias('app_state.exportedMnemonic')

  includeFancy: true

)

export default InfoExportController
