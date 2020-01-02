import Component  from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, union } from '@ember/object/computed'
import { isBlank, isNone } from "@ember/utils"
import { A }  from '@ember/array'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'
import { copy } from 'ember-copy'


LabelPicker = Component.extend(
  classNames: ['form-group']

  label: null

  selection: null
  newLabels: null

  maxItems: '6'

  wallet: service('cm-wallet')

  walletLabels: alias('wallet.labels')

  allLabels: union('walletLabels', 'newLabels')

  ensureArray: (->
    if isNone(@get('selection'))
      @set('selection', A())
  ).observes('selection')

  setup: (->
    @set('selection', A()) if isNone(@get('selection'))
    @set('newLabels', A()) if isNone(@get('newLabels'))
  ).on('init').on('didReceiveAttrs')


  updateLabels: ->
    newL = copy(@get('newLabels'))
    @set('newLabels', A())
    @get('walletLabels').pushObjects(newL) if newL

  actions:
    setNewLabel: (text) ->
      @get('newLabels').pushObject(text)

    lostFocus: (select) ->
      console.error "lostfocus"
      selection = @get('selection')
      @updateLabels()
      waitIdle().then( => @sendAction('on-finish', @get('selection')))

    updateLabels: ->
      selection = @get('selection')
      @updateLabels()
      @sendAction('on-finish', @get('selection'))

    createOnEnter: (select, e) ->
      if (((e.keyCode == 13) || (e.keyCode == 32))  && select.isOpen && !select.highlighted && !isBlank(select.searchText))
        selection = @get('selection')
        if (!selection.includes(select.searchText))
          this.get('newLabels').pushObject(select.searchText)
          select.actions.choose(select.searchText)
        e.preventDefault()

)

export default LabelPicker
