`import CMCore from 'npm:melis-api-js'`
`import CmPtxs from 'melis-cm-svcs/services/cm-ptxs'`
`import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'`


C = CMCore.C

PtxService = CmPtxs.extend(
  aa: Ember.inject.service('aa-provider')

  # PTX OPS =========================================================================================



  txFeeBump: (account, txHash, multiplier) ->
    @getPtxByHash(txHash, account).then((ptx) => @ptxFeeBump(ptx, multiplier))


  ptxFeeBumpById: (account, ptxId, multiplier) ->
    @findById(ptxId, account).then((ptx) => @ptxFeeBump(ptx, multiplier))


  ptxFeeBump: (ptx, multiplier) ->
    api = @get('cm.api')
    { state, account } = Ember.getProperties(ptx, 'state', 'account')

    api.payPrepareFeeBump(state, autoSignIfValidated: true, feeMultiplier: multiplier).then((newState) =>
      newPtx = @ptxFromState(newState)
      @ptxSign(newPtx)

      return newPtx
    ).catch((error) ->
      Ember.Logger.error '[CM-PTX] FeeBump error:', error
      throw error
    )

  ptxReissue: (ptx) ->
    recipients = Ember.get(ptx, 'cmo.recipients')
    account = Ember.get(ptx, 'account')
    @ptxPrepare(account, recipients, propose: true)


  ptxPrepare: (account, recipients, options = {}) ->
    Ember.RSVP.reject('no account') if Ember.isEmpty(acct = Ember.get(account, 'cmo'))
    api = @get('cm.api')

    if !Ember.isEmpty(recipients)
      op = (tfa) ->
        plainRecs = recipients.map((r) ->
          Ember.getProperties(r, 'address', 'amount', 'meta', 'labels')
        )
        api.payPrepare(acct, plainRecs, tfa: tfa.payload)

      @get('aa').tfaAuth(op, 'Auth').then((state) =>
        ptx = @ptxFromState(state, account)

        if ptx.get('isMultisig') || options.propose
          @ptxPropose(ptx)
        else
          @addPtx(id: ptx.id, account: account, cmo: ptx)
          Ember.RSVP.resolve(ptx)
      ).catch((err) ->
        Ember.Logger.error '[CM-PTX] Error:', err
        throw err
      )
    else
      Ember.RSVP.reject('no recipients')


  #
  #
  #
  ptxSign: (ptx) ->
    api = @get('cm.api')

    if ptx
      waitTime(200).then( =>
        @_signPtx(ptx)
      ).catch((err) ->
        Ember.Logger.error('[PTX] Sign failed: ', err)
        throw err
      )

    else
      Ember.RSVP.reject('no state')


  _signPtx: (ptx) ->

    state = ptx.get('state')
    api = @get('cm.api')

    Ember.setProperties(ptx,
      signing: true
      signingProgress: 0
    )

    state.progressCallback = (progress) =>
      r = Ember.RSVP.defer()
      Ember.run( this, (->
        Ember.set(ptx, 'signingProgress', Math.floor(((progress.currStep + 1 )/progress.totalSteps) * 100))
        Ember.run.later(this, (->
          r.resolve()
        ), 50)
      ))
      return r.promise

    op = (tfa) ->
      api.payConfirm(state, tfa.payload)

    @get('aa').tfaAuth(op, "Confirm Transaction").then((data) =>
      Ember.set(ptx, 'signingProgress', 100)
      @trigger('signed-ptx', ptx, data)
      return data
    ).catch((err) ->
      Ember.Logger.error '[CM-PTX] Error:', err
      throw err
    ).finally( =>
      Ember.set(ptx, 'signing', false)
    )

)

`export default PtxService`
