`import Ember from 'ember'`
`import randomBytes from 'npm:randombytes'`
`import otplib from 'npm:otplib'`
`import { task, taskGroup } from 'ember-concurrency'`

APP_ID = 'Melis'
APP_ISSUER = 'CM'

otp = otplib.default

TotpEnroll = Ember.Component.extend(


  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  currentDevice: null
  currentSecret: null

  validToken: null
  enrollError: null


  apiOps: taskGroup().drop()

  currentUrl: ( ->
    if device = @get('currentDevice')
      "otpauth://totp/#{APP_ID}:#{device.value}?secret=#{@get('currentSecret')}&issuer=#{APP_ISSUER}"
  ).property('currentDevice', 'currentSecret')


  provisioningId: (->
    @get('cm.currentWallet.pubKey').substring(0, 16)
  ).property('cm.currentWallet')



  enroll: task ( ->
    secret = otp.authenticator.generateSecret()
    @setProperties
      currentSecret: secret
      enrollError: null

    api = @get('cm.api')
    id = @get('provisioningId')

    op = (tfa) ->
      api.tfaEnrollStart({name: 'rfc6238', value: id, data: secret}, tfa.payload)

    try
      res = yield @get('aa').tfaAuth(op, "Enroll TOTP")
      @set('currentDevice', res.device)
      @sendAction('on-new-enroll', res.device)

    catch error
      Ember.Logger.error "error enrolling totp: ", error
      @set 'enrollError', error.msg
  )


  enrollFinish: task( (device, token)->
    @set 'enrollError', null
    api = @get('cm.api')

    try
      res = yield api.tfaEnrollFinish(name: device.name, value: device.value, code: token)
      @sendAction('on-new-complete-enroll', res.device)
    catch error
      Ember.Logger.error "Error doing enroll finish: ", error
      @set 'enrollError', error.msg

  ).group('apiOps')

  abort: ( ->
    @get('aa').delayedRefreshTfaState()
    @sendAction('on-enroll-abort')
  ).on('willDestroyElement')

  actions:
    enrollFinish: (device, code) ->
      if device && code
        @get('enrollFinish').perform(device, code)

    enrollTotp: ->
      @set 'validToken', null
      @get('enroll').perform()

    showToken: ->
      if secret = @get('currentSecret')
        @set 'validToken', otp.totp.generate(secret)

)

`export default TotpEnroll`