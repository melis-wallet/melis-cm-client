import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

import Logger from 'melis-cm-svcs/utils/logger'

MainAbsRoute = Route.extend(


  cm: service('cm-session')
  ab: service('cm-addressbook')

  scanner: service('scanner-provider')

  model: ->
    @get('ab').findAll()

  #
  #
  scanAddress: ->
    @get('scanner').independentScan().then((data) =>
      if (addr = @get('scanner').getAddressFromData(data))
        @transitionToRoute('main.abs.new', [], queryParams: {newaddr: addr})
    ).catch((err) ->
      Logger.error "Scanner aborted", err
    )

  actions:
    deleteEntry: (entry) ->
      abook = @get('ab')
      abook.delete(entry)

    scanAddress: ->
      @scanAddress()

)

export default MainAbsRoute
