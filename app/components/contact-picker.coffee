import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, sort, empty } from '@ember/object/computed'
import { get, set, getProperties } from '@ember/object'

import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'
import CMCore from 'npm:melis-api-js'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C

ContactPicker = Component.extend(SlyEnabled,

  cm: service('cm-session')
  ab: service('cm-addressbook')

  searchSeed: null
  addrs: null

  shown: true

  scope: 'address'
  coin: null
  resolveAddress: false

  searchable: true
  'return-btn': null

  entriesSorting: ['name:asc']
  entriesSorted: sort('addrs', 'entriesSorting')

  empty: empty('addrs')
  noMatches: empty('filteredEntries')

  filteredEntries: (->
    @get('entriesSorted').filter( (item) =>
      return false if ((coin = @get('coin')) && (get(item, 'coin') != coin))
      if seed = @get('searchSeed')
        seed = seed.toLowerCase()
        item.getWithDefault('name', '').toLowerCase().includes(seed)
      else
        true
    )
  ).property('entriesSorted.[]', 'searchSeed', 'coin')

  notifySly: (->
    if @get('filteredEntries.length')
      @reloadSly()
  ).observes('filteredEntries.[]', 'shown')


  setup: (->
    @get('ab').findAll().then((res) => @set('addrs', res))
  ).on('init')

  actions:
    selectEntry: (entry) ->
      @sendAction('on-selected', entry)
      if @get('scope') == 'address'
        if get(entry, 'type') == C.AB_TYPE_ADDRESS
          @sendAction('on-recipient-selected', 'address', get(entry, 'address'), entry)
        else
          if id = get(entry, 'pubId')
            if @get('resolveAddress')
              @get('cm.api').getPaymentAddressForAccount(id).then((res) =>
                @sendAction('on-recipient-selected', 'address', res, entry)
              ).catch((err) ->
                Logger.error 'Error fetching Payment Address: ', err
              )
            else
              @sendAction('on-recipient-selected', 'cm', getProperties(entry, 'pubId', 'alias'), entry)

    returnBtn: ->
      @sendAction('on-return')

)

export default ContactPicker