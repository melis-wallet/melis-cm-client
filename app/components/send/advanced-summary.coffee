import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

AdvancedSummary = Component.extend(

  cm: service('cm-session')


  account: null
  parent: null


  valid: alias('parent.valid')

  actions:
    preparePayment: ->
      @sendAction('on-prepare')

    resetPayment: ->
      @sendAction('on-reset')

)

export default AdvancedSummary


