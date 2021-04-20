import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'
import { get, set } from '@ember/object'

import Configuration from 'melis-cm-svcs/utils/configuration'
import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'
import BackButton from '../../mixins/backbutton-support'
import CMCore from 'melis-api-js'
import { translationMacro as t } from "ember-i18n"
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

C = CMCore.C


EnrollWizard = Component.extend(AsWizard, BackButton,

  cm: service('cm-session')
  credentials: service('cm-credentials')
  aa: service('aa-provider')
  coinsvc: service('cm-coin')

  defaultAccountName: t('account.defaults.name')

  step: 1
  stepBack: true

  completeOn: 4

  genProgress: 0
  genState: 'enroll.state.idle'

  genFailed: null
  serverLocked: false

  skipBackup: false
  skipAccount: false

  simpleAccount: C.TYPE_2OF2_SERVER
  chosenPin: null

  apiOps: taskGroup().drop()

  doInviteCheck: false

  availableCoins: alias('coinsvc.enabledCoins')

  selectedCoin: ( ->
    if c = @get('coin')
      @get('availableCoins').findBy('unit', c)
  ).property('coin', 'availableCoins')

  coin: null

  setup: (->
    @set('coin', @get('availableCoins.firstObject.unit'))
    if !@get('credentials.validCredentials')
      @set('skipBackup', true)
      @markCompleted(1, 2)
  ).on('willInsertElement')


  closeWallet: task( ->
    return unless @get('cm.currentWallet')

    Logger.warn "Wallet is already open during enroll"
    try
      yield @get('cm').walletClose()
    catch err
      Logger.error "failed closing wallet: ", err
  )

  enrollWalletWithInvite: task((pin, coin)->
    cm = @get('cm')
    @get('credentials').reset()

    @updateState 30, 'enroll.state.idle'
    @set('stepBack', false)

    yield @get('closeWallet').perform()

    if @get('skipAccount')
      try
        yield @get('aa').checkInvite( (token) -> cm.enrollWallet(pin) )

        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Logger.error "enroll failed: ", err
        @set 'genFailed', err.msg

    else
      try
        yield @get('aa').checkInvite( (token) -> cm.enrollWallet(pin) )
        @updateState 60, 'enroll.state.acreate'
        account = yield cm.accountCreate(coin: coin, type: @get('simpleAccount'), meta: {name: @get('defaultAccountName').toString()})
        if account
          cm.selectAccount(account.get('pubId'))
        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Logger.error "Enroll failed: ", err
        if err.ex == 'CmServerLockedException'
          @set 'serverLocked', true
        else
          @set 'genFailed', (err.msg || err)
  ).group('apiOps')

  enrollWallet: task((pin, coin)->
    cm = @get('cm')
    @get('credentials').reset()

    @updateState 30, 'enroll.state.idle'
    @set('stepBack', false)

    yield @get('closeWallet').perform()

    if @get('skipAccount')
      try
        yield cm.enrollWallet(pin)
        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Logger.error "enroll failed: ", err
        @set 'genFailed', err.msg

    else
      try
        yield cm.enrollWallet(pin)
        @updateState 60, 'enroll.state.acreate'
        account = yield cm.accountCreate(coin: coin, type: @get('simpleAccount'), meta: {name: @get('defaultAccountName').toString()})
        if account
          cm.selectAccount(account.get('pubId'))
        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Logger.error "Enroll failed: ", err
        if err.ex == 'CmServerLockedException'
          @set 'serverLocked', true
        else
          @set 'genFailed', (err.msg || err)
  ).group('apiOps')


  updateState: (progress, state) ->
    @set 'genProgress', progress
    @set 'genState', state

  performEnroll:  ->
    # Always skip while in beta
    if true #  @get('skipAccount')
      if @get('doInviteCheck')
        @get('enrollWalletWithInvite').perform(@get('chosenPin'), @get('coin'))
      else
        @get('enrollWallet').perform(@get('chosenPin'), @get('coin'))

  actions:
    coinSelected: ->
      @markCompleted(3, 4)
      @performEnroll()

    selectCoin: (c) ->
      if unit = get(c, 'unit')
        @set('coin', unit)

    startOver: ->
      @setProperties
        step: 2
        stepBack: true
        genProgress: 0
        genFailed: null
        serverLocked: false
        genState: 'Idling'
        chosenPin: null

    changeSimpleAccount: (type) ->
      @set 'simpleAccount', type

    typeSelected: ->
      @markCompleted(3, 4)
      @performEnroll()

    confirmEnroll: ->
      @markCompleted(1, 2)

    doneSetPIN: (pin)->
      @set 'chosenPin', pin
      @markCompleted(2, 3)
      if @get('skipAccount')
        @markCompleted(3, 4)
        @performEnroll()

    completeEnroll: ->
      @markCompleted(4)
)

export default EnrollWizard
