import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias, sort, empty } from '@ember/object/computed'

AbsController = Controller.extend(

  ab: service('cm-addressbook')

  searchSeed: null

  entriesSorting: ['name:asc']
  entriesSorted: sort('model', 'entriesSorting')

  empty: empty('model')
  noMatches: empty('filteredEntries')

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

export default AbsController
