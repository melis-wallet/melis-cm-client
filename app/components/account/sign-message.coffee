import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get } from '@ember/object'
import RSVP from 'rsvp'

import { task, taskGroup } from 'ember-concurrency'
import { validator, buildValidations } from 'ember-cp-validations'

import Logger from 'melis-cm-svcs/utils/logger'

Validations = buildValidations(

  addressText: [
    validator('presence', presence: true)
    validator('coin-address', coin: alias('model.account.coin'), allowURI: true )
  ]

)

SignMessage = Component.extend(Validations, 

  cm: service('cm-session')
  aa: service('aa-provider')

  addressText: null

  account: null
  address: null
  text: null
  signature: null

  formattedSig: alias('signature')

  textChanged: ( -> @set('signature', null) ).observes('text')

  signingDisabled: ( -> @get('doSign.isRunning') || !@get('text')).property('text', 'doSign.isRunning')

  doSign: task(->
    {text, account, address} = @getProperties('text', 'account', 'address')
    if text && account && address

      op = (tfa) =>
        RSVP.resolve(@get('cm.api').signMessageWithAA(get(account, 'cmo'), address, text.trim()))

      try
        sign = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
        if sign then @set('signature', sign)
      catch error
        Logger.error "Error: ", error
  )

  searchAddress: task((address) ->
    return unless (account = @get('account'))

    try
      res = yield @get('cm.api').addressGet(get(account, 'cmo'), address)
      if add = get(res, 'address')
        @set('address', add)
    catch error
      Logger.error "Error: ", error

  )

  setup: (->
    if (addr = @get('addressText'))
      @get('searchAddress').perform(addr)
  ).on('init')

  actions:
    doSign: ->
      @get('doSign').perform()


    searchAddress: ->
      if address = @get('addressText')
        @get('searchAddress').perform(address)
)

export default SignMessage
