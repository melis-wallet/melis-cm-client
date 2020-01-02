import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'
import { get, set } from '@ember/object'

ICONS = {
  email: 'fa fa-envelope-o'
  sms:  'fa fa-phone-square'
  xmpp:  'fa fa-comments-o'
  telegram:  'fa fa-telegram'
  rfc6238: 'fa fa-mobile'
  regtest: 'fa fa-cogs'
  unknown: 'fa fa-get-pocket'

}

TFADeviceIcon = Helper.extend(

  i18n:  service()

  compute: (params, hash) ->
    device = params[0]

    if deviceName = get(device, 'name')?.toLowerCase()
      ICONS[deviceName] || ICONS['unknown']
    else
      ICONS[device] || ICONS['unknown']

)

export default TFADeviceIcon