import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'


MainAbsNewRoute = Route.extend(

  abook: service('cm-addressbook')

  model: (params)->
    @get('abook').find(params.entry_id)
)

export default MainAbsNewRoute
