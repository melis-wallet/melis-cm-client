`import Ember from 'ember'`

UrgentAlerts = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  firstPtx: Ember.computed.alias('cm.currentAccount.ptxs.lastObject')

  show: Ember.computed.notEmpty('firstPtx')


)


`export default UrgentAlerts`