import Component from '@ember/component'
import { inject as service } from '@ember/service'

DashSummary = Component.extend(

  cm: service('cm-session')

  account: null
  detailExpanded: false
  classNames: ['widget-basic']

  actions:
    toggleExpand: ->
      @toggleProperty('detailExpanded')

)

export default DashSummary
