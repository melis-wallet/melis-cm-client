import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

MainAccountIndexRoute = Route.extend(

  cm: service('cm-session')
  credentials: service('cm-credentials')

  model: (params) ->
    @get('cm').waitForReady()
)

export default MainAccountIndexRoute