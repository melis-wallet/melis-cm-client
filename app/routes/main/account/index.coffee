`import Ember from 'ember'`


MainAccountIndexRoute = Ember.Route.extend(

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')


  model: (params) ->
    cm = @get('cm')
    cm.waitForReady()
)

`export default MainAccountIndexRoute`