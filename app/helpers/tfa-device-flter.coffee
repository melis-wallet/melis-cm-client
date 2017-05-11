`import Ember from 'ember'`

TfaDeviceFiter = Ember.Helper.extend(

  aa: Ember.inject.service('aa-provider')

  compute: (params, hash) ->
    driver = params[0]
    @get('aa.tfaDevices').filterBy('name', driver)

)

`export default TfaDeviceFiter`