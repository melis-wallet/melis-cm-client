`import Ember from 'ember'`

PreparedTxSigners = Ember.Component.extend(


  cosigners: Ember.computed.alias('account.info.cosigners')
  signers: Ember.A()

  'table-class': 'table-no-border'

  signatures: null

  signersUpdate: ( ->

    signatures = @get('signatures')
    signers = @get('signers')
    if signers
      signers.forEach( (s) =>

        found = signatures.findBy('pubId', Ember.get(s, 'accountPubId'))
        if found
          Ember.set(found, 'signed', Ember.get(s, 'sigDate'))
      )
  ).observes('signers.[]')


  setup: ( ->
    if (cosigners = @get('cosigners'))
      @set 'signatures', @get('cosigners').copy(true)
      @signersUpdate()
  ).observes('account', 'signers', 'cosigners').on('init')
)

`export default PreparedTxSigners`
