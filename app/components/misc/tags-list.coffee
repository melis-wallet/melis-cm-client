import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { equal } from '@ember/object/computed'
import { isNone } from '@ember/utils'
import { A } from '@ember/array'

TagsList = Component.extend(

  selection: null
  labelsSet: null

  editable: true
  editing: false

  tagsClass: 'label m-sm'
  controlIcon: 'fa fa-ellipsis-h'
  controlSize: 'sm'

  maxItems: '6'

  control: 'left'

  controlOnLeft: equal('control', 'left')
  controlOnRight: equal('control', 'right')

  setup: ( ->
    @set('selection', A()) if isNone(@get('selection'))
  ).on('didInsertElement')

  actions:
    edit: ->
      @set('editing', true)

    doneEdit: (selection) ->
      @set('editing', false)
      @sendAction('on-done-edit', selection)
)

export default TagsList
