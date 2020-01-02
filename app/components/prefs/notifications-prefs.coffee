import Component from '@ember/component'
import { inject as service } from '@ember/service'

NotifPrefs = Component.extend(

  cm: service('cm-session')
  notif: service('global-notifications')
)

export default NotifPrefs
