import Component from '@ember/component'
import { alias } from '@ember/object/computed'
import { A } from '@ember/array'
import { get, set } from '@ember/object'
import { copy } from 'ember-copy'

PreparedTxSigners = Component.extend(

  cosigners: alias('account.info.cosigners')
  signers: A()

  signatures: null

  signersUpdate: ( ->

    signatures = @get('signatures')
    signers = @get('signers')
    if signers
      signers.forEach( (s) =>

        found = signatures.findBy('pubId', get(s, 'accountPubId'))
        if found
          set(found, 'signed', get(s, 'sigDate'))
      )
  ).observes('signers.[]')


  setup: ( ->
    if (cosigners = @get('cosigners'))
      @set 'signatures', copy(@get('cosigners'), true)
      @signersUpdate()
  ).observes('account', 'signers', 'cosigners').on('init')
)

export default PreparedTxSigners
