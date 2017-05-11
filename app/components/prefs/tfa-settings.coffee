`import Ember from 'ember'`

TfaSettings = Ember.Component.extend(
  aa: Ember.inject.service('aa-provider')

  actions:
    setDefault: ->
      @get('aa').setDefaultTfa()
)

`export default TfaSettings`
