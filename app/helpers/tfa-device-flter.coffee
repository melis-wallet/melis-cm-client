import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'

TfaDeviceFiter = Helper.extend(

  aa: service('aa-provider')

  compute: (params, hash) ->
    driver = params[0]
    @get('aa.tfaDevices').filterBy('name', driver)

)

export default TfaDeviceFiter