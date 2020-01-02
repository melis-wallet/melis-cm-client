import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

JoinRoute = Route.extend(

  cm: service('cm-session')

  model: (params) ->

    @get('cm').waitForConnect().then( =>
      @get('cm.api').accountGetPublicInfo(code: params.code).then((info) ->
        info.code = params.code
        return info
      )
    )
)

export default JoinRoute
