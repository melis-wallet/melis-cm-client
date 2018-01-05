`import Ember from 'ember'`
`import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'`
`import CMCore from 'npm:melis-api-js'`

C = CMCore.C

ContactPicker = Ember.Component.extend(SlyEnabled,

  cm: Ember.inject.service('cm-session')
  ab: Ember.inject.service('cm-addressbook')

  searchSeed: null
  addrs: null

  shown: true

  scope: 'address'
  coin: null
  resolveAddress: false

  searchable: true
  'return-btn': null

  entriesSorting: ['name:asc']
  entriesSorted: Ember.computed.sort('addrs', 'entriesSorting')

  empty: Ember.computed.empty('addrs')
  noMatches: Ember.computed.empty('filteredEntries')

  filteredEntries: (->
    @get('entriesSorted').filter( (item) =>
      return false if ((coin = @get('coin')) && (Ember.get(item, 'coin') != coin))
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
        if Ember.get(entry, 'type') == C.AB_TYPE_ADDRESS
          @sendAction('on-recipient-selected', 'address', Ember.get(entry, 'address'), entry)
        else
          if id = Ember.get(entry, 'pubId')
            if @get('resolveAddress')
              @get('cm.api').getPaymentAddressForAccount(id).then((res) =>
                @sendAction('on-recipient-selected', 'address', res, entry)
              ).catch((err) ->
                Ember.Logger.error 'Error fetching Payment Address: ', err
              )
            else
              @sendAction('on-recipient-selected', 'cm', Ember.getProperties(entry, 'pubId', 'alias'), entry)





    returnBtn: ->
      @sendAction('on-return')

)

`export default ContactPicker`