import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

ScannerModal = Component.extend(

  provider: service('scanner-provider')
  modalId: alias('provider.modalId')

  mediaError: null

  tab: null

  actions:
    successAcquire: (data)->
      @get('provider').successAcquire(data)

    mediaError: (error) ->
      @setProperties
        mediaError: error
        tab: 'upload'
)

export default ScannerModal
