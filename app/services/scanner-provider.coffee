`import Ember from 'ember'`
`import { parseURI } from '../utils/uris'`


ScannerProvider = Ember.Service.extend(

  cm: Ember.inject.service('cm-session')
  modalManager: Ember.inject.service('modals-manager')

  cordovaPlatform: Ember.inject.service('ember-cordova/platform')
  device: Ember.inject.service('device-support')
  routing: Ember.inject.service('-routing')

  modalId: 'scanner-modal'
  modalOpen: false


  getAddressFromData: (data) ->
    addr =
      if Ember.isBlank(data.scheme)
        data.data
      else if data.scheme.toLowerCase() == 'bitcoin'
        data.address

    return addr if @get('cm.api').validateAddress(addr)


  actOnScan: (data) ->
    num = @get('cm.currentAccount.num')
    if (addr = @getAddressFromData(data))
      @get("routing").transitionTo('main.account.ops.send', [num], {address: addr})

    if data.scheme
      switch data.scheme.toLowerCase()
        when 'bitcoin'
          @get("routing").transitionTo('main.account.ops.send', [num], {address: data.address})
        else
          # tbd
          Ember.Logger.error "Unknown scheme"

  startGenericScanner: (opts) ->
    @independentScan(opts).then( (r) => @actOnScan(r) )


  independentScan: (opts) ->
    if @get('device.isMobile')
      return @nativeScan().then((r) ->
        Ember.Logger.debug('NATIVE scanner succeded: ', r)
        return r
      )

    else
      return @acquireCode().then((r) =>
        Ember.Logger.debug('JS scanner succeded: ', r)
        return r
      )


  nativeScan: ->
    pending = Ember.RSVP.defer()
    cordova.plugins.barcodeScanner.scan(
      ((data) =>
        Ember.Logger.debug "Scanner success: ", data
        try
          res = parseURI(data.text)
        catch e
          Ember.Logger.error "Error in acquisition: ", e
        pending.resolve(res)
      ), ( (e) =>
        pending.reject.e
        Ember.Logger.error "Native scanner: ", e
      )
    )
    return pending.promise

  acquireCode: ->
    if request = @get('pendingRequest')
      Ember.RSVP.reject('Already acquiring')
    else
      pending = Ember.RSVP.defer()
      @set('pendingRequest', pending)
      @get('modalManager').showModal(@get('modalId')).then((res)->

        #
        # take care of this should the modal close other than
        # dismiss OR successful scanning
        #
      ).catch( =>
        @abortAcquire('closed')
      )
      return pending.promise


  abortAcquire: (why) ->
    if request = @get('pendingRequest')
      @set('pendingRequest', null)
      request.reject(why)

  successAcquire: (data) ->
    Ember.Logger.debug "Scanner data: ", data

    @get('modalManager').hideModal(@get('modalId'), 'success')
    if request = @get('pendingRequest')
      @set('pendingRequest', null)

      try
        res = parseURI(data)
      catch e
        Ember.Logger.error "Error in acquisition: ", e
      request.resolve(res)

)

`export default ScannerProvider`
