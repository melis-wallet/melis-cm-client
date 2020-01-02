import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

import StyleBody from 'ember-leaf-core/mixins/leaf-style-body'


ApplicationRoute = Route.extend(StyleBody,

  cdv: service('device-support')

  classNames: ['theme-melis']


  beforeModel: ->
    @get('cdv')

  actions:
    error: (e) ->
      if handler = @get('cm.report_error')
        handler(e)

)

export default ApplicationRoute
