import Mixin from '@ember/object/mixin'
import { inject as service } from '@ember/service'
import { get, set } from '@ember/object'

import Logger from 'melis-cm-svcs/utils/logger'

FingerPrintAuth = Mixin.create(

  fpa: service('fingerprint-auth')

  disableFpa: false

  didInsertElement: ->
    @._super(arguments...)
    return if  @get('disableFpa')

    checkfp =  =>
      if @get('fpa.successfullyEnrolled')
        Logger.debug "[fpa-auth] can do fpa"
        @_fpaLogin()
      else
        Logger.debug "[fpa-auth] can NOT do fpa"
      @get('fpa').off('service-ready', this, checkfp)


    if @get('fpa.serviceReady')
      checkfp()
    else
      @get('fpa').on('service-ready', this, checkfp)

  _fpaLogin: ->
    Logger.debug "[fpa-auth] logging in"
    @get('fpa').login().then( (res) =>
      Logger.debug('[fpa-auth] Success: ', res)
      if (pin = get(res, 'pin'))
        @onValidFpa(pin) if @onValidFpa
    ).catch((err) ->
      Logger.error('[fpa-auth] Error: ', err)
    )
)

export default FingerPrintAuth
