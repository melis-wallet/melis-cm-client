import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'

import Logger from 'melis-cm-svcs/utils/logger'

APPID='http://localhost:4200'

U2FEnroll = Component.extend(

  cm: service('cm-session')
  aa: service('aa-provider')

  provisioningId: (->
    @get('cm.currentWallet.pubKey').substring(0, 16)
  ).property('cm.currentWallet')

  enroll: ->

    api = @get('cm.api')
    id = @get('provisioningId')

    op = (tfa) ->
      api.tfaEnrollStart({name: 'u2f', value: id, appId: APPID}, tfa.payload)

    @get('aa').tfaAuth(op, "enroll TOTP").then((res) =>
      console.log "success:", res

      u2fdata = JSON.parse(res.value)


      request = u2fdata.registerRequests
      console.log "REQUEST: ", request
      u2f.register(request, [], ((result) ->
        console.log "u2f", result
      ))

    ).catch((err) =>
      @set 'enrollError', err.msg
      Logger.error "error enrolling email: ", err
    )


  actions:
    doEnrollKey: ->
      @enroll()

)

export default U2FEnroll