import Mixin from '@ember/object/mixin'
import { inject as service } from '@ember/service'

ModalAlerts = Mixin.create(

  modalManager: service('modals-manager')

  showModalAlert: (data) ->
    @get('modalManager').showAlert(data)

)

export default ModalAlerts