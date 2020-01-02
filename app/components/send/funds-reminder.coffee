import Component from '@ember/component'
import { inject as service } from '@ember/service'

FundsReminder = Component.extend(

  cm: service('cm-session')
  account: null
)

export default FundsReminder
