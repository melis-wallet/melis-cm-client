import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'

import config from '../config/environment'


RemoteLink = Helper.extend(

  cm: service('cm-session')

  compute: (params, hash) ->
    routeName = params[0]
    model = params[1]
    @get('cm').webUrlFor(routeName, model, hash)
)

export default RemoteLink