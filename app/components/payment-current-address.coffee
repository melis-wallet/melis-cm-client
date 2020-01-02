import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, equal } from '@ember/object/computed'
import { isEmpty } from '@ember/utils'
import { scheduleOnce } from '@ember/runloop'

import Alertable from 'ember-leaf-core/mixins/leaf-alertable'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


PLACEHOLDER = 'newaddr.active.default-ph'

PaymentNewaddress = Component.extend(Alertable,

  service: service('cm-address-provider')
  cm: service('cm-session')
  i18n: service()

  currentAddress: alias('service.current.currentAddress')
  code: alias('currentAddress.addressURL')
  format: alias('currentAddress.format')

  isStandard: equal('format', 'standard')

  activeAddress: alias('service.current.activeAddress')

  showToggle: alias('currentAddress.coin.features.altaddrs')

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
      Logger.error "Error: ", error
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
      Logger.error "Error: ", error
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
    toggleFormat: ->
      if @get('isStandard')
        @set('format', 'legacy')
      else
        @set('format', 'standard')

    toggleMini: ->
      @toggleProperty('keepMini')

    renew: ->
      @get('renewAddr').perform()

    makeCurrentActive: ->
      @set('keepMini', false)
      @get('makeCurrentActive').perform(@get('i18n').t(PLACEHOLDER).toString())


)

export default PaymentNewaddress
