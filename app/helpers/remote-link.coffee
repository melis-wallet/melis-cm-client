`import Ember from 'ember'`
`import config from '../config/environment'`


RemoteLink = Ember.Helper.extend(

  cm: Ember.inject.service('cm-session')

  compute: (params, hash) ->
    routeName = params[0]
    model = params[1]
    @get('cm').webUrlFor(routeName, model, hash)
)

`export default RemoteLink`