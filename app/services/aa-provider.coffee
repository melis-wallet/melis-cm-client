`import Ember from 'ember'`
`import InviteMixin from '../mixins/beta-invite'`
`import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'`


AAProvider = Ember.Service.extend(InviteMixin,

  cm: Ember.inject.service('cm-session')
  creds: Ember.inject.service('cm-credentials')
  modalManager: Ember.inject.service('modals-manager')
  routing: Ember.inject.service('-routing')
  i18n: Ember.inject.service()


  #
  # request the pin after 20 seconds
  #
  askPinAfter: 2000

  #
  # State of the modal for auth
  #
  modalId: 'aa-modal'

  modalOpen: false

  aComponent: null

  modalType: null

  #
  # TFA
  #
  tfaDrivers: Ember.computed.alias('cm.config.tfaDrivers')

  tfaConfig: null

  tfaDevices: null

  tfaOperation: null

  #
  #
  #
  immediatePin: null

  #
  # Last AA/TFA error
  #
  currentError: null

  # other data passed to the AA component
  componentData: null

  #
  # devices that are enabled and ready to use
  #
  tfaValidDevices: Ember.computed.filterBy('tfaDevices', 'verified', true)

  #
  # at least one device is enabled
  #
  tfaIsEnabled: Ember.computed.notEmpty('tfaValidDevices')

  #
  # TFA devices, grouped by name
  #
  tfaAllDevices: ( ->
    allDevs = {}
    devices = @get('tfaDevices')

    @get('tfaDrivers').forEach((d) ->
      allDevs[d] = devices.filterBy('name', Ember.get(d, 'name'))
    )

    allDevs
  ).property('tfaDevices', 'tfaDrivers')


  #
  #
  #
  lastPinRequest: 0


  #
  # if tfs is enabled, use it. If not ask for local pin
  #
  tfaOrLocalPin: (operation, prompt, mandatory, immediate) ->
    if @get('tfaIsEnabled')
      @tfaAuth(operation, prompt)
    else
      @askLocalPin(operation, prompt, mandatory, immediate).then( (pindata)=> @tfaAuth(operation, prompt, pindata))


  #
  # wraps a an operation requiring TFA authentication. The operation block must return a promise
  #
  tfaAuth: (operation, prompt, hintpin)  ->
    pending = Ember.RSVP.defer()
    if operation

      operation(payload: null, valid: false).then((res) =>
        # operation is successful
        pending.resolve(res)
      ).catch((err) =>
        # operation failed, needs PIN
        if err.ex == 'TfaMissingPinException'
          if request = @get('pendingRequest')
            pending.reject(ex: 'TfaBusy', msg: @get('i18n').t('aa.error.busy'))
          else
            @setProperties(
              currentError: null
              tfaOperation: operation
              modalType: 'remotepin'
              aComponent: 'tfa/remote-pin-input'
              pendingRequest: pending
            )

            if hintpin
              @validRemotePin(hintpin.pin, hintpin.devicePass)
            else
              @get('modalManager').showModal(@get('modalId')).catch( =>
                @rejectPending(ex: 'TfaAborted', msg: @get('i18n').t('aa.error.tfa-req'))
              )


        # operation failed, needs 2fa
        else if err.ex == 'TfaMissingException'
          if request = @get('pendingRequest')
            pending.reject(ex: 'TfaBusy', msg: @get('i18n').t('aa.error.busy'))
          else
            @setProperties(
              currentError: null
              tfaOperation: operation
              modalType: 'tfa'
              aComponent: 'tfa/tfa-prompt'
              pendingRequest: pending
            )
            @get('modalManager').showModal(@get('modalId')).catch( =>
              @rejectPending(ex: 'TfaAborted', msg: @get('i18n').t('aa.error.tfa-req'))
            )

        # operation failed
        else
          pending.reject(err)
      )
    else
      pending.reject('no operation to tfa')
    return pending.promise


  #
  # Ask a pin to complete the operation
  # mandatory means the pin gets asked even if it was recently asked
  #
  askLocalPin: (operation, prompt, mandatory, immediate)->
    pending = Ember.RSVP.defer()

    if request = @get('pendingRequest')
      pending.reject(ex: 'TfaBusy', msg:  @get('i18n').t('aa.error.busy'))
    else if !mandatory && ( @get('lastPinRequest') > (Date.now() - @get('askPinAfter')))
      operation(type: 'pin', pin: null, valid: false, devicePass: null, payload: null).then((res) -> pending.resolve(res))
    else
      @setProperties(
        modalType: 'pin'
        tfaOperation: operation
        aComponent: 'wallet/pin-input'
        pendingRequest: pending
        immediatePin: immediate
      )
      @get('modalManager').showModal(@get('modalId')).catch( =>
        @rejectPending(ex: 'TfaAborted', msg: @get('i18n').t('aa.error.tfa-pin-req'))
      )

    return pending.promise


  validTfa: (data) ->
    @set('currentError', null)
    operation = @get('tfaOperation')

    if operation && !Ember.get(operation, 'running')
      Ember.set(operation, 'running', true)
      operation(type: 'tfa', payload: data, valid: true).then((res) =>
        @dismissAndResolve(res)
      ).catch((err) =>
        if err.ex == 'TfaInvalidException'
          # failed, tfa was invalid
          @set('currentError', @get('i18n').t('aa.error.invalid-tfa-token'))
        else
          # failed for another reason
          @dismissAndReject(err)
      ).finally( ->
        Ember.set(operation, 'running', false)
      )
    else
      @dismissAndResolve(null)


  validRemotePin: (pin, devicePass) ->
    @setProperties
      currentError: null
      componentData: null

    operation = @get('tfaOperation')

    if operation && !Ember.get(operation, 'running')
      Ember.set(operation, 'running', true)
      operation(type: 'remotepin', payload: {pin: pin}, valid: true).then((res) =>
        @dismissAndResolve(res)
      ).catch((err) =>
        if err.ex == 'CmInvalidDeviceException'
          if err.attemptsLeft
            @setProperties
              currentError: @get('i18n').t('aa.error.invalid-remote-pin')
              componentData: { attemptsLeft: err.attemptsLeft, wrongPin: true }
          else
            # device has been deleted
            @setProperties
              componentData: { invalidDevice: true }
              currentError: @get('i18n').t('aa.error.invalid-device')
            @get('creds').reset()
            @get('routing').transitionTo('wallet.no-creds')

        else if err.ex == 'TfaInvalidDeviceException'
          @setProperties
            componentData: { invalidDevice: true }
            currentError: @get('i18n').t('aa.error.invalid-device')
          @get('creds').reset()
          @get('routing').transitionTo('wallet.no-creds')
        else
          # failed for another reason
          @dismissAndReject(err)
      ).finally( ->
        Ember.set(operation, 'running', false)
      )
    else
      @dismissAndResolve(null)


  validPin: (pin, devicePass) ->
    if @get('immediatePin')
      operation = @get('tfaOperation')
      if operation
        if !Ember.get(operation, 'running')
          Ember.set(operation, 'running', true)
          operation(type: 'pin', pin: pin, devicePass: devicePass, payload: null, valid: true).then((res) =>
            @set('lastPinRequest', Date.now())
            @dismissAndResolve(res)
          ).finally( ->
            Ember.set(operation, 'running', false)
          )
      else
        @dismissAndResolve(null)
    else
      @dismissAndResolve(pin: pin, devicePass: devicePass)


  dismissAndResolve: (res) ->
    @get('modalManager').hideModal(@get('modalId'), 'success')
    if request = @get('pendingRequest')
      @set('pendingRequest', null)
      request.resolve(res)

  dismissAndReject: (err) ->
    @get('modalManager').hideModal(@get('modalId'))
    @rejectPending(err)

  rejectPending: (err) ->
    if request = @get('pendingRequest')
      @set('pendingRequest', null)
      request.reject(err)


  initalizeTfaConfig: ->
    @get('cm.api').tfaGetWalletConfig().then((cfg) =>
      @set('tfaConfig', cfg)
    )

  delayedRefreshTfaState: ->
    waitIdle().then( => @refreshTfaState())

  refreshTfaState: ->
    api = @get('cm.api')
    api.tfaGetWalletConfig().then((res) =>
      Ember.Logger.debug "TFA wallet config: ", res
      if res.devices
        @set 'tfaDevices', Ember.A(res.devices)

    ).catch((err) ->
      Ember.Logger.error "Error fetching TFA config: ", err
    )

  setup: ( ->
    @set 'tfaDevices', Ember.A()
    if @get('cm.ready')
      @initalizeTfaConfig().then( =>
        @refreshTfaState()
      ).catch((err) ->
        Ember.Logger.error('- AA: failed initialization', err)
      )

  ).observes('cm.ready').on('init')

)

`export default AAProvider`

