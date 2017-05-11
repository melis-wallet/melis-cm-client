`import Ember from 'ember'`

ScannerModal = Ember.Component.extend(

  provider: Ember.inject.service('scanner-provider')
  modalId: Ember.computed.alias('provider.modalId')

  mediaError: null

  actions:
    successAcquire: (data)->
      @get('provider').successAcquire(data)

    mediaError: (error) ->
      @set 'mediaError', error
)

`export default ScannerModal`
