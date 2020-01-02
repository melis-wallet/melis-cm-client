import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'
import { get, set } from '@ember/object'


PREFIX = 'tfa.devices'

TFADeviceName = Helper.extend(

  i18n: service()

  compute: (params, hash) ->
    device = params[0]

    if deviceName = get(device, 'name')
      @get('i18n').t("#{PREFIX}.#{deviceName}")
    else
      @get('i18n').t("#{PREFIX}.unknown")

)

export default TFADeviceName