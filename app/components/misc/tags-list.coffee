`import Ember from 'ember'`

TagsList = Ember.Component.extend(

  selection: null
  labelsSet: null

  editable: true
  editing: false

  tagsClass: 'label m-sm'
  controlIcon: 'fa fa-ellipsis-h'
  controlSize: 'sm'

  maxItems: '6'

  control: 'left'

  controlOnLeft: Ember.computed.equal('control', 'left')
  controlOnRight: Ember.computed.equal('control', 'right')

  setup: ( ->
    @set('selection', Ember.A()) if Ember.isNone(@get('selection'))
  ).on('didInsertElement')

  actions:
    edit: ->
      @set('editing', true)
      #Ember.run.scheduleOnce 'afterRender', this, (-> @.$('.selectize-input').click())

    doneEdit: (selection) ->
      @set('editing', false)
      @sendAction('on-done-edit', selection)

)

`export default TagsList`
