`import Ember from 'ember'`

FingerPrintAuth = Ember.Mixin.create(

  fpa: Ember.inject.service('fingerprint-auth')

  disableFpa: false

  didInsertElement: ->
    @._super(arguments...)
    return if  @get('disableFpa')

    checkfp =  =>
      if @get('fpa.successfullyEnrolled')
        Ember.Logger.debug "[fpa-auth] can do fpa"
        @_fpaLogin()
      else
        Ember.Logger.debug "[fpa-auth] can NOT do fpa"
      @get('fpa').off('service-ready', this, checkfp)


    if @get('fpa.serviceReady')
      checkfp()
    else
      @get('fpa').on('service-ready', this, checkfp)

  _fpaLogin: ->
    Ember.Logger.debug "[fpa-auth] logging in"
    @get('fpa').login().then( (res) =>
      Ember.Logger.debug('[fpa-auth] Success: ', res)
      if (pin = Ember.get(res, 'pin'))
        @onValidFpa(pin) if @onValidFpa
    ).catch((err) ->
      Ember.Logger.error('[fpa-auth] Error: ', err)
    )

)

`export default FingerPrintAuth`
