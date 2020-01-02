import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

import AuthenticatedRoute from '../../mixins/authenticated-route'


InfoExportRoute = Route.extend(AuthenticatedRoute,

  app_state: service('app-state')

  actions:
    willTransition: (transition) ->
      @set('app_state.exportedGeneratorQR', null)
      @set('app_state.exportedMnemonic', null)
      true

)

export default InfoExportRoute
