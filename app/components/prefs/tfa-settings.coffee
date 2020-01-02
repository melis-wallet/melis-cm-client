import Component from '@ember/component'
import { inject as service } from '@ember/service'

TfaSettings = Component.extend(
  aa: service('aa-provider')

  actions:
    setDefault: ->
      @get('aa').setDefaultTfa()
)

export default TfaSettings
