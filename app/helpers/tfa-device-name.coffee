`import Ember from 'ember'`

PREFIX = 'tfa.devices'

TFADeviceName = Ember.Helper.extend(

  i18n:  Ember.inject.service()

  compute: (params, hash) ->
    device = params[0]

    if deviceName = Ember.get(device, 'name')
      @get('i18n').t("#{PREFIX}.#{deviceName}")
    else
      @get('i18n').t("#{PREFIX}.unknown")

)

`export default TFADeviceName`