`import Ember from 'ember'`


ModalAlerts = Ember.Mixin.create(

  modalManager: Ember.inject.service('modals-manager')

  showModalAlert: (data) ->
    @get('modalManager').showAlert(data)


)

`export default ModalAlerts`