`import Ember from 'ember'`


MainAbsNewRoute = Ember.Route.extend(

  abook: Ember.inject.service('cm-addressbook')


  model: (params)->
    @get('abook').find(params.entry_id)

)

`export default MainAbsNewRoute`
