import Controller from '@ember/controller'
import { inject as service } from '@ember/service'

ImportController = Controller.extend(
  credentials: service('cm-credentials')

  actions:
    abortWizard: (-> @transitionToRoute('wallet.welcome'))
)

export default ImportController
