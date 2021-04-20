import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'
import { get, set, computed } from '@ember/object'
import { A } from '@ember/array'

import { validator, buildValidations } from 'ember-cp-validations'


Validations = buildValidations(
  mnemonic: [
    validator('alias', 'cleanMnemonic')
  ]
  cleanMnemonic: [
    validator('presence', true)
    validator('melis-mnemonic')
  ]
  passphrase: [
    validator('presence', presence: true, disabled: computed.not('model.encrypted'))
    validator('length', min: 4, max: 32, disabled: computed.not('model.encrypted'))
  ]
)



MnemonicInput = Component.extend(Validations, 

  credentials: service('cm-credentials')
  cm: service('cm-session')

  'enter-submit': true

  wordlists: (->
    Object.keys(@get('credentials.wordlists')).map((key) ->
      {value: key, label: key}
    ) || A()
  ).property('credentials.wordlist')

  selectedList: null

  disabled: false

  wordlist: ( ->
    wl = @get('credentials.wordlists')
    wl[@get('selectedList.value')] || wl['en']
  ).property('selectedList', 'credentials.wordlists.[]')

  setup: ( ->
    @set('selectedList', @get('wordlists').findBy('value', (@get('cm.locale') || 'en')) || @get('wordlist.firstObject'))
  ).on('didInsertElement')


  mnemonic: null

  hasData: notEmpty('mnemonic')

  cleanMnemonic: ( ->
    @get('mnemonic')?.join(' ').trim()?.replace(/[\n\r\t]+/gm, ' ').replace(/\s{2,10}/g, ' ')?.toLowerCase()
  ).property('mnemonic')

  encrypted: ( ->
    if @get('validations.attrs.mnemonic.isValid')
      @get('credentials').isMnemonicEncrypted(@get('cleanMnemonic'))
    else
      false
  ).property('mnemonic')


  actions:

    submitMnemonicEnter: ->
      if @get('validations.isValid') && @get('enter-submit')
        @sendAction('on-valid-mnemonic', @get('cleanMnemonic'), @get('passphrase'))

    submitMnemonic: ->
      if @get('validations.isValid')
        @sendAction('on-valid-mnemonic', @get('cleanMnemonic'), @get('passphrase'))
)

export default MnemonicInput


