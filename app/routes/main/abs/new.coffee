import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

MainAbsNewRoute = Route.extend(

  abook: service('cm-addressbook')

  actions:
    addAbEntry: (entry) ->
      abook = @get('abook')
      abook.push(entry).then( =>
        @transitionTo('main.abs')
      )
)

export default MainAbsNewRoute
