import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias, sort } from '@ember/object/computed'
import { get, set } from '@ember/object'

import { mergedProperty } from 'melis-cm-svcs/utils/misc'
import { task, taskGroup } from 'ember-concurrency'
import CMCore from 'melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'


C = CMCore.C

MainAddressIdxController = Controller.extend(


  allAddresses: alias('model.list')
  hasNext: alias('model.hasNext')

  addressesSorting: ['lastRequested:desc']
  addresses: sort('allAddresses', 'addressesSorting')

  currentPage: 0

  pageOps: taskGroup().drop()

  nextPage: task( ->
    page = @incrementProperty('currentPage')
    try
      res = yield @get('cm.api').addressesGet(@get('cm.currentAccount.cmo'), page: page, sortField: 'lastRequested', sortDir: C.DIR_DESCENDING)
      @set('hasNext', res.hasNext)
      newAddrs = get(res, 'list')
      if newAddrs
        @get('model.list').pushObjects(newAddrs)
    catch error
      Logger.error "Error: ", error
  ).group('pageOps')

  actions:
    nextPage: ->
      @get('nextPage').perform()


)

export default MainAddressIdxController
