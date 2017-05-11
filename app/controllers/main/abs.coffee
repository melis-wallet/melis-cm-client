`import Ember from 'ember'`

AbsController = Ember.Controller.extend(

  ab: Ember.inject.service('cm-addressbook')


  searchSeed: null

  entriesSorting: ['name:asc']
  entriesSorted: Ember.computed.sort('model', 'entriesSorting')

  empty: Ember.computed.empty('model')
  noMatches: Ember.computed.empty('filteredEntries')

  filteredEntries: (->
    if seed = @get('searchSeed')
      seed = seed.toLowerCase()
      @get('entriesSorted').filter( (item)->
        item.getWithDefault('name', '').toLowerCase().includes(seed)

      )
    else
      @get('entriesSorted')
  ).property('entriesSorted.[]', 'searchSeed')

)

`export default AbsController`
