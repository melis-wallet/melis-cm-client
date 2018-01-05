`import Ember from 'ember'`

ICONS = {
  email: 'fa fa-envelope-o'
  sms:  'fa fa-phone-square'
  xmpp:  'fa fa-comments-o'
  telegram:  'fa fa-telegram'
  rfc6238: 'fa fa-mobile'
  regtest: 'fa fa-cogs'
  unknown: 'fa fa-get-pocket'

}

TFADeviceIcon = Ember.Helper.extend(

  i18n:  Ember.inject.service()

  compute: (params, hash) ->
    device = params[0]

    if deviceName = Ember.get(device, 'name')?.toLowerCase()
      ICONS[deviceName] || ICONS['unknown']
    else
      ICONS[device] || ICONS['unknown']

)

`export default TFADeviceIcon`