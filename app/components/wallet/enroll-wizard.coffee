`import Ember from 'ember'`
`import Configuration from 'melis-cm-svcs/utils/configuration'`
`import AsWizard from 'ember-leaf-core/mixins/leaf-as-wizard'`
`import BackButton from '../../mixins/backbutton-support'`
`import CMCore from 'npm:melis-api-js'`
`import { translationMacro as t } from "ember-i18n"`
`import { task, taskGroup } from 'ember-concurrency'`

C = CMCore.C

EnrollWizard = Ember.Component.extend(AsWizard, BackButton,

  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')
  aa: Ember.inject.service('aa-provider')

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


  setup: (->
    if !@get('credentials.validCredentials')
      @set('skipBackup', true)
      @markCompleted(1, 2)
  ).on('willInsertElement')


  closeWallet: task( ->
    return unless @get('cm.currentWallet')

    Ember.Logger.warn "Wallet is already open during enroll"
    try
      yield @get('cm').walletClose()
    catch err
      Ember.Logger.error "failed closing wallet: ", err
  )

  enrollWalletWithInvite: task((pin)->
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
        Ember.Logger.error "enroll failed: ", err
        @set 'genFailed', err.msg

    else
      try
        yield @get('aa').checkInvite( (token) -> cm.enrollWallet(pin) )
        @updateState 60, 'enroll.state.acreate'
        account = yield cm.accountCreate(type: @get('simpleAccount'), meta: {name: @get('defaultAccountName').toString()})
        if account
          cm.selectAccount(account.get('num'))
        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Ember.Logger.error "Enroll failed: ", err
        if err.ex == 'CmServerLockedException'
          @set 'serverLocked', true
        else
          @set 'genFailed', (err.msg || err)
  ).group('apiOps')

  enrollWallet: task((pin)->
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
        Ember.Logger.error "enroll failed: ", err
        @set 'genFailed', err.msg

    else
      try
        yield cm.enrollWallet(pin)
        @updateState 60, 'enroll.state.acreate'
        account = yield cm.accountCreate(type: @get('simpleAccount'), meta: {name: @get('defaultAccountName').toString()})
        if account
          cm.selectAccount(account.get('num'))
        @updateState 100, 'enroll.state.done'
        @set 'enrollDone', true
      catch err
        Ember.Logger.error "Enroll failed: ", err
        if err.ex == 'CmServerLockedException'
          @set 'serverLocked', true
        else
          @set 'genFailed', (err.msg || err)
  ).group('apiOps')


  updateState: (progress, state) ->
    @set 'genProgress', progress
    @set 'genState', state

  actions:
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
      if @get('doInviteCheck')
        @get('enrollWalletWithInvite').perform(@get('chosenPin'))
      else
        @get('enrollWallet').perform(@get('chosenPin'))

    confirmEnroll: ->
      @markCompleted(1, 2)

    doneSetPIN: (pin)->
      @set 'chosenPin', pin
      # Always skip while in beta
      if true #  @get('skipAccount')
        @markCompleted(2, 3)
        @markCompleted(3, 4)
        if @get('doInviteCheck')
          @get('enrollWalletWithInvite').perform(@get('chosenPin'))
        else
          @get('enrollWallet').perform(@get('chosenPin'))
      else
        @markCompleted(2, 3)

    completeEnroll: ->
      @markCompleted(4)

)

`export default EnrollWizard`
