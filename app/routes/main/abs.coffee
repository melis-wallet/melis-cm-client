`import Ember from 'ember'`


MainAbsRoute = Ember.Route.extend(


  cm: Ember.inject.service('cm-session')
  ab: Ember.inject.service('cm-addressbook')

  scanner: Ember.inject.service('scanner-provider')

  model: ->
    @get('ab').findAll()

  #
  #
  scanAddress: ->
    @get('scanner').independentScan().then((data) =>
      if (addr = @get('scanner').getAddressFromData(data))
        @transitionToRoute('main.abs.new', [], queryParams: {newaddr: addr})
    ).catch((err) ->
      Ember.Logger.error "Scanner aborted", err
    )

  actions:
    deleteEntry: (entry) ->
      abook = @get('ab')
      abook.delete(entry)

    scanAddress: ->
      @scanAddress()




)

`export default MainAbsRoute`
