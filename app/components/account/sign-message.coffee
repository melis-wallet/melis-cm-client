`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`

Validations = buildValidations(

  addressText: [
    validator('presence', presence: true)
    validator('bitcoin-address')
  ]

)


SignMessage = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')

  addressText: null

  account: null
  address: null
  text: null
  signature: null

  formattedSig: Ember.computed.alias('signature')

  textChanged: ( -> @set('signature', null) ).observes('text')


  signingDisabled: ( -> @get('doSign.isRunning') || !@get('text')).property('text', 'doSign.isRunning')

  doSign: task(->
    {text, account, address} = @getProperties('text', 'account', 'address')
    if text && account && address

      op = (tfa) =>
        Ember.RSVP.resolve(@get('cm.api').signMessageWithAA(Ember.get(account, 'cmo'), address, text.trim()))

      try
        sign = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
        if sign then @set('signature', sign)
      catch error
        Ember.Logger.error "Error: ", error
  )

  searchAddress: task((address) ->
    return unless (account = @get('account'))

    try
      res = yield @get('cm.api').addressGet(Ember.get(account, 'cmo'), address)
      if add = Ember.get(res, 'address')
        @set('address', add)
    catch error
      Ember.Logger.error "Error: ", error

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

`export default SignMessage`
