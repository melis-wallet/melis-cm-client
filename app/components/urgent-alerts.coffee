import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'

UrgentAlerts = Component.extend(


  cm: service('cm-session')
  firstPtx: alias('cm.currentAccount.ptxs.lastObject')

  show: notEmpty('firstPtx')
)


export default UrgentAlerts