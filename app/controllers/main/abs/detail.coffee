import Controller from '@ember/controller'
import { get, set } from '@ember/object'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

AbsController = Controller.extend(

  accountInfo: null

  lazyfetchInfo: task( ->
    @set('accountInfo', null)

    if (entry = @get('model')) && get(entry, 'isCm') && (val = get(entry, 'val'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: val)
        @set('accountInfo', res)
      catch error
        Logger.error error
  )

  modelChanged: ( ->
    @get('lazyfetchInfo').perform()
  ).observes('model')

)

export default AbsController
