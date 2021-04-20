import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

AAModal = Component.extend(

  provider: service('aa-provider')

  modalId: alias('provider.modalId')
  aComponent: alias('provider.aComponent')
  type: alias('provider.modalType')


  currentError: alias('provider.currentError')
  currentPrompt: alias('provider.currentPrompt')

  componentData: alias('provider.componentData')
  running:  alias('provider.tfaOperation.running')
  done: alias('provider.tfaOperation.done')


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

export default AAModal
