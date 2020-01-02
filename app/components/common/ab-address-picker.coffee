import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, sort } from '@ember/object/computed'

AbPicker = Component.extend(

  ab: service('cm-addressbook')
  modalId: alias('cm.modalId')

  entriesSorting: ['name:asc']
  entriesSorted: sort('addrs', 'entriesSorting')

  setup: (->
    @set('addrs', @get('ab').findAll())
  ).on('init')
)

export default AbPicker