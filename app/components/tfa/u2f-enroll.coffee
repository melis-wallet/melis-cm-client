`import Ember from 'ember'`


APPID='http://localhost:4200'

U2FEnroll = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

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
      console.error "error enrolling email: ", err
    )


  actions:
    doEnrollKey: ->
      @enroll()

)

`export default U2FEnroll`