`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`


Validations = buildValidations(
  mnemonic: [
    validator('alias', 'cleanMnemonic')
  ]
  cleanMnemonic: [
    validator('presence', true)
    validator('melis-mnemonic')
  ]
  passphrase: [
    validator('presence', presence: true, disabled: Ember.computed.not('model.encrypted'))
    validator('length', min: 8, max: 32, disabled: Ember.computed.not('model.encrypted'))
  ]
)



MnemonicInput = Ember.Component.extend(Validations, ValidationsHelper,

  credentials: Ember.inject.service('cm-credentials')
  cm: Ember.inject.service('cm-session')

  'enter-submit': true

  wordlists: (->
    Object.keys(@get('credentials.wordlists')).map((key) ->
      {value: key, label: key}
    ) || Ember.A()
  ).property('credentials.wordlist')

  selectedList: null

  wordlist: ( ->
    wl = @get('credentials.wordlists')
    wl[@get('selectedList.value')] || wl['en']
  ).property('selectedList', 'credentials.wordlists.[]')

  setup: ( ->
    @set('selectedList', @get('wordlists').findBy('value', (@get('cm.locale') || 'en')) || @get('wordlist.firstObject'))
  ).on('didInsertElement')


  mnemonic: null

  hasData: Ember.computed.notEmpty('mnemonic')

  cleanMnemonic: ( ->
    @get('mnemonic')?.join(' ').trim()?.replace(/[\n\r\t]+/gm, ' ').replace(/\s{2,10}/g, ' ')?.toLowerCase()
  ).property('mnemonic')

  encrypted: ( ->
    if @get('validations.attrs.mnemonic.isValid')
      @get('credentials').isMnemonicEncrypted(@get('cleanMnemonic'))
    else
      false
  ).property('validations.attrs.mnemonic.isValid')


  actions:

    submitMnemonicEnter: ->
      if @get('isValid') && @get('enter-submit')
        @sendAction('on-valid-mnemonic', @get('cleanMnemonic'), @get('passphrase'))

    submitMnemonic: ->
      if @get('isValid')
        @sendAction('on-valid-mnemonic', @get('cleanMnemonic'), @get('passphrase'))
)

`export default MnemonicInput`


