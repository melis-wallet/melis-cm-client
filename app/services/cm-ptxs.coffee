import Service, { inject as service } from '@ember/service'
import { get, set, getProperties, setProperties } from '@ember/object'
import { isEmpty } from '@ember/utils'
import { run, later } from '@ember/runloop'
import RSVP from 'rsvp'

import CmPtxs from 'melis-cm-svcs/services/cm-ptxs'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'

import Logger from 'melis-cm-svcs/utils/logger'


PtxService = CmPtxs.extend(
  aa: service('aa-provider')

  # PTX OPS =========================================================================================



  txFeeBump: (account, txHash, multiplier) ->
    @getPtxByHash(txHash, account).then((ptx) =>@ptxFeeBump(ptx, multiplier))


  ptxFeeBumpById: (account, ptxId, multiplier) ->
    @findById(ptxId, account).then((ptx) => @ptxFeeBump(ptx, multiplier))


  ptxFeeBump: (ptx, multiplier) ->
    api = @get('cm.api')
    { state, account } = getProperties(ptx, 'state', 'account')

    api.payPrepareFeeBump(state, autoSignIfValidated: true, feeMultiplier: multiplier).then((newState) =>
      newPtx = @ptxFromState(newState)
      @ptxSign(newPtx)

      return newPtx
    ).catch((error) ->
      Logger.error '[CM-PTX] FeeBump error:', error
      throw error
    )

  ptxReissue: (ptx) ->
    recipients = get(ptx, 'cmo.recipients')
    account = get(ptx, 'account')
    @ptxPrepare(account, recipients, propose: true)


  ptxPrepare: (account, recipients, options = {}) ->
    RSVP.reject('no account') if isEmpty(acct = get(account, 'cmo'))
    api = @get('cm.api')

    if !isEmpty(recipients)
      op = (tfa) ->
        plainRecs = recipients.map((r) ->
          getProperties(r, 'address', 'amount', 'meta', 'labels')
        )
        api.payPrepare(acct, plainRecs, tfa: tfa.payload)

      @get('aa').tfaAuth(op, 'Auth').then((state) =>
        ptx = @ptxFromState(state, account)

        if ptx.get('isMultisig') || options.propose
          @ptxPropose(ptx)
        else
          @addPtx(id: ptx.id, account: account, cmo: ptx)
          RSVP.resolve(ptx)
      ).catch((err) ->
        Logger.error '[CM-PTX] Error:', err
        throw err
      )
    else
      RSVP.reject('no recipients')


  #
  #
  #
  ptxSign: (ptx) ->
    api = @get('cm.api')

    if ptx
      waitTime(200).then( =>
        @_signPtx(ptx)
      ).catch((err) ->
        Logger.error('[PTX] Sign failed: ', err)
        throw err
      )

    else
      RSVP.reject('no state')


  _signPtx: (ptx) ->

    state = ptx.get('state')
    api = @get('cm.api')

    setProperties(ptx,
      signing: true
      signingProgress: 0
    )

    state.progressCallback = (progress) =>
      r = RSVP.defer()
      run( this, (->
        set(ptx, 'signingProgress', Math.floor(((progress.currStep + 1 )/progress.totalSteps) * 100))
        later(this, (->
          r.resolve()
        ), 50)
      ))
      return r.promise

    op = (tfa) ->
      api.payConfirm(state, tfa.payload)

    @get('aa').tfaAuth(op, "Confirm Transaction").then((data) =>
      set(ptx, 'signingProgress', 100)
      @trigger('signed-ptx', ptx, data)
      return data
    ).catch((err) ->
      Logger.error '[CM-PTX] Error:', err
      throw err
    ).finally( => set(ptx, 'signing', false))

)

export default PtxService
