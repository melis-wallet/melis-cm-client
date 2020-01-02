import Controller from '@ember/controller'
import { inject as service } from '@ember/service'

RecoverController = Controller.extend(
  credentials: service('cm-credentials')

  actions:
    abortWizard: (-> @transitionToRoute('wallet.welcome'))
)

export default RecoverController
