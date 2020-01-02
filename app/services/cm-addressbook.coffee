import Service, { inject as service } from '@ember/service'
import CMCore from 'npm:melis-api-js'
import CmAddressbook from 'melis-cm-svcs/services/cm-addressbook'
import RSVP from 'rsvp'

C = CMCore.C

CmAddressbookE = CmAddressbook.extend(

  modalManager: service('modals-manager')

  modalId: 'ab-pick-modal'

  pickAddressForJoin: ->
    if request = @get('pendingRequest')
      RSVP.reject('Already have a picker')
    else
      pending = RSVP.defer()
      @set('pendingRequest', pending)
      @get('modalManager').showModal(@get('modalId')).then(->

      ).catch( =>
        @rejectPending('closed')
      )
      return pending.promise
)

export default CmAddressbookE
