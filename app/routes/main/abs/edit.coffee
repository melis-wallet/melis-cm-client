import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'


MainAbsNewRoute = Route.extend(

  abook: service('cm-addressbook')


  model: (params)->
    @get('abook').find(params.entry_id)

  actions:
    updateAbEntry: (entry) ->
      abook = @get('abook')
      abook.update(entry).then( (e) =>
        @transitionTo('main.abs.detail', entry)
      )
)

export default MainAbsNewRoute
