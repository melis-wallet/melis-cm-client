`import Ember from 'ember'`
`import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'`


LabelPicker = Ember.Component.extend(
  classNames: ['form-group']

  label: null

  selection: null
  newLabels: null

  labelsSet: null

  maxItems: '6'

  info: Ember.inject.service('cm-account-info')

  accountLabels: ( ->
    if labelsSet = @get('labelsSet')
      @get("info.currentLabels.#{labelsSet}")
  ).property('info.currentLabels', 'labelsSet')

  allLabels: Ember.computed.union('accountLabels', 'newLabels')

  ensureArray: (->
    if Ember.isNone(@get('selection'))
      @set('selection', Ember.A())
  ).observes('selection')

  setup: (->
    @set('selection', Ember.A()) if Ember.isNone(@get('selection'))
    @set('newLabels', Ember.A()) if Ember.isNone(@get('newLabels'))
  ).on('init').on('didReceiveAttrs')


  updateLabels: ->
    newL = @get('newLabels').copy()
    @set('newLabels', Ember.A())
    @get('accountLabels').pushObjects(newL)

  actions:
    setNewLabel: (text) ->
      @get('newLabels').pushObject(text)

    gotFocus: (select) ->
      console.error "gotFocus"


    lostFocus: (select) ->
      console.error "lostfocus"
      return
      selection = @get('selection')
      waitIdle().then( => @sendAction('on-finish', @get('selection')))

    updateLabels: ->
      selection = @get('selection')
      @updateLabels()
      @sendAction('on-finish', @get('selection'))

    createOnEnter: (select, e) ->
      if ((e.keyCode == 13) && select.isOpen && !select.highlighted && !Ember.isBlank(select.searchText))
        selection = @get('selection')
        if (!selection.includes(select.searchText))
          this.get('newLabels').pushObject(select.searchText)
          select.actions.choose(select.searchText)

)

`export default LabelPicker`
