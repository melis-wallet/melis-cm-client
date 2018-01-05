`import Ember from 'ember'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`
`import { task, taskGroup } from 'ember-concurrency'`

PLACEHOLDER = 'newaddr.active.default-ph'

PaymentNewaddress = Ember.Component.extend(Alertable,

  service: Ember.inject.service('cm-address-provider')
  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  currentAddress: Ember.computed.alias('service.current.currentAddress')
  code: Ember.computed.alias('service.current.currentAddress.addressURL')

  activeAddress: Ember.computed.alias('service.current.activeAddress')

  error: null
  noResources: false

  keepMini: false
  showCode: true

  apiOps: taskGroup().drop()

  minimized: ( ->
    @get('activeAddress') && !@get('keepMini')
  ).property('activeAddress', 'keepMini')

  makeCurrentActive: task( (info) ->
    @setProperties
      error: null
      noResources: false
    try
      addr = yield @get('service').requestFromCurrent(null, info: info)
      @set('activeAddress', addr)
      @sendAction('on-select-active', addr)
    catch error
      Ember.Logger.error "Error: ", error
      if error.ex == 'CmNoResourcesException'
        @set 'noResources', true
      else
        @set 'error', error
  ).group('apiOps')

  renewAddr: task( ->
    @set 'error', null
    try
      yield @get('service').getCurrentAddress()
    catch error
      Ember.Logger.error "Error: ", error
      if error.ex == 'CmNoResourcesException'
        @set 'noResources', true
      else
        @set 'error', error
  ).group('apiOps')

  observeCode: ( ->
    if code = @get('code')
      @sendAction('on-code-change', code)
  ).observes('code')

  updateCurrentAddress: (data) ->
    @get('service').updateCurrentAddress(data)

  setup: ( -> @get('service').ensureCurrent() ).on('init')

  #
  #
  #
  actions:
    toggleMini: ->
      @toggleProperty('keepMini')

    renew: ->
      @get('renewAddr').perform()

    makeCurrentActive: ->
      @set('keepMini', false)
      @get('makeCurrentActive').perform(@get('i18n').t(PLACEHOLDER).toString())


)
`export default PaymentNewaddress`
