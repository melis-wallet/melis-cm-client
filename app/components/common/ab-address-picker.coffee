`import Ember from 'ember'`

AbPicker = Ember.Component.extend(

  ab: Ember.inject.service('cm-addressbook')
  modalId: Ember.computed.alias('cm.modalId')

  entriesSorting: ['name:asc']
  entriesSorted: Ember.computed.sort('addrs', 'entriesSorting')

  setup: (->

    @set('addrs', @get('ab').findAll())
  ).on('init')
)