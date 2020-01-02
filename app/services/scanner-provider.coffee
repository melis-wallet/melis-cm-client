import Service, { inject as service } from '@ember/service'
import { isBlank } from '@ember/utils'
import RSVP from 'rsvp'

import { parseURI } from '../utils/uris'

import Logger from 'melis-cm-svcs/utils/logger'


ScannerProvider = Service.extend(

  cm: service('cm-session')
  modalManager: service('modals-manager')
  coinsvc: service('cm-coin')

  cordovaPlatform: service('ember-cordova/platform')
  device: service('device-support')
  routing: service('-routing')

  modalId: 'scanner-modal'
  modalOpen: false


  getAddressFromData: (data, coin) ->
    addr =
      if isBlank(data.scheme)
        data.data
      else if @get('coinsvc.validSchemes').includes(data.scheme.toLowerCase())
        data.address

    if coin
      return addr if @get('coinsvc').validateAddress(addr, coin)
    else

      # TODO
      return addr


  actOnScan: (data) ->
    id = @get('cm.currentAccount.pubId')
    if (addr = @getAddressFromData(data))
      @get("routing").transitionTo('main.account.ops.send', [id], {address: addr})

    if data.scheme
      switch data.scheme.toLowerCase()
        when 'bitcoin'
          @get("routing").transitionTo('main.account.ops.send', [id], {address: data.address})
        else
          # tbd
          Logger.error "Unknown scheme"

  startGenericScanner: (opts) ->
    @independentScan(opts).then( (r) => @actOnScan(r) )


  independentScan: (opts) ->
    if @get('device.isMobile')
      return @nativeScan().then((r) ->
        Logger.debug('NATIVE scanner succeded: ', r)
        return r
      )

    else
      return @acquireCode().then((r) =>
        Logger.debug('JS scanner succeded: ', r)
        return r
      )


  nativeScan: ->
    pending = RSVP.defer()
    cordova.plugins.barcodeScanner.scan(
      ((data) =>
        Logger.debug "Scanner success: ", data
        try
          res = parseURI(data.text)
        catch e
          Logger.error "Error in acquisition: ", e
        pending.resolve(res)
      ), ( (e) =>
        pending.reject.e
        Logger.error "Native scanner: ", e
      )
    )
    return pending.promise

  acquireCode: ->
    if request = @get('pendingRequest')
      RSVP.reject('Already acquiring')
    else
      pending = RSVP.defer()
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
    Logger.debug "Scanner data: ", data

    @get('modalManager').hideModal(@get('modalId'), 'success')
    if request = @get('pendingRequest')
      @set('pendingRequest', null)

      try
        res = parseURI(data)
      catch e
        Logger.error "Error in acquisition: ", e
      request.resolve(res)

)

export default ScannerProvider
