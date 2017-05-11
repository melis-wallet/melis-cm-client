`import Ember from 'ember'`


MainAbsNewRoute = Ember.Route.extend(

  abook: Ember.inject.service('cm-addressbook')

  actions:
    addAbEntry: (entry) ->
      abook = @get('abook')
      abook.push(entry).then( =>
        @transitionTo('main.abs')
      )
)

`export default MainAbsNewRoute`
