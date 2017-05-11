`import Ember from 'ember'`

DashSummary = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  account: null
  detailExpanded: false
  classNames: ['widget-basic']

  actions:
    toggleExpand: ->
      @toggleProperty('detailExpanded')

)

`export default DashSummary`
