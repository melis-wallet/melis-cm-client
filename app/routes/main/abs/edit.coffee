`import Ember from 'ember'`


MainAbsNewRoute = Ember.Route.extend(

  abook: Ember.inject.service('cm-addressbook')


  model: (params)->
    @get('abook').find(params.entry_id)

  actions:
    updateAbEntry: (entry) ->
      abook = @get('abook')
      abook.update(entry).then( (e) =>
        @transitionTo('main.abs.detail', entry)
      )
)

`export default MainAbsNewRoute`
