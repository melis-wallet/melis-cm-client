`import CMCore from 'npm:melis-api-js'`
`import CmAddressbook from 'melis-cm-svcs/services/cm-addressbook'`

C = CMCore.C

CmAddressbookE = CmAddressbook.extend(


  modalManager: Ember.inject.service('modals-manager')


  modalId: 'ab-pick-modal'


  pickAddressForJoin: ->
    if request = @get('pendingRequest')
      Ember.RSVP.reject('Already have a picker')
    else
      pending = Ember.RSVP.defer()
      @set('pendingRequest', pending)
      @get('modalManager').showModal(@get('modalId')).then(->

      ).catch( =>
        @rejectPending('closed')
      )
      return pending.promise




)

`export default CmAddressbookE`
