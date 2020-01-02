import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'


ProfileRoute = Route.extend(

  cm: service('cm-session')

  model: (params) ->

    @get('cm').waitForConnect().then( =>
      identifier = decodeURIComponent(params.identifier)
      @get('cm.api').accountGetPublicInfo(name: identifier)
    )
)

export default ProfileRoute
