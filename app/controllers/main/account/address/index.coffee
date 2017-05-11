`import Ember from 'ember'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`
`import { task, taskGroup } from 'ember-concurrency'`

MainAddressIdxController = Ember.Controller.extend(


  allAddresses: Ember.computed.alias('model.list')
  hasNext: Ember.computed.alias('model.hasNext')

  addressesSorting: ['lastRequested:desc']
  addresses: Ember.computed.sort('allAddresses', 'addressesSorting')

  currentPage: 0

  pageOps: taskGroup().drop()

  nextPage: task( ->
    page = @incrementProperty('currentPage')
    try
      res = yield @get('cm.api').addressesGet(@get('cm.currentAccount.cmo'), page: page, sortField: 'lastRequested')
      @set('hasNext', res.hasNext)
      newAddrs = Ember.get(res, 'list')
      if newAddrs
        console.error newAddrs
        @get('model.list').pushObjects(newAddrs)
    catch error
      Ember.Logger.error "Error: ", error
  ).group('pageOps')

  actions:
    nextPage: ->
      @get('nextPage').perform()


)

`export default MainAddressIdxController`
