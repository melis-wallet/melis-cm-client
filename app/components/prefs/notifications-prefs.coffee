`import Ember from 'ember'`

NotifPrefs = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  notif: Ember.inject.service('global-notifications')

)

`export default NotifPrefs`
