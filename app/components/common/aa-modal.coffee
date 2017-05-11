`import Ember from 'ember'`

AAModal = Ember.Component.extend(

  provider: Ember.inject.service('aa-provider')

  modalId: Ember.computed.alias('provider.modalId')
  aComponent: Ember.computed.alias('provider.aComponent')
  type: Ember.computed.alias('provider.modalType')


  currentError: Ember.computed.alias('provider.currentError')
  currentPrompt: Ember.computed.alias('provider.currentPrompt')

  componentData: Ember.computed.alias('provider.componentData')
  running:  Ember.computed.alias('provider.tfaOperation.running')


  actions:
    validPin: (pin, devicePass) ->
      @get('provider').validPin(pin, devicePass)

    validRemotePin: (pin, devicePass) ->
      @get('provider').validRemotePin(pin, devicePass)

    validTfa: (data) ->
      @get('provider').validTfa(data)

    validToken: (data) ->
      @get('provider').validToken(data)

)

`export default AAModal`
