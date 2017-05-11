`import Ember from 'ember'`
`import AuthenticatedRoute from '../../mixins/authenticated-route'`


InfoExportRoute = Ember.Route.extend(AuthenticatedRoute,

  app_state: Ember.inject.service('app-state')

  actions:
    willTransition: (transition) ->
      @set('app_state.exportedGeneratorQR', null)
      @set('app_state.exportedMnemonic', null)
      true

)

`export default InfoExportRoute`
