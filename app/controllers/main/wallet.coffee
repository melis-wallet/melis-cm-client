`import Ember from 'ember'`


UNITS =
  mBTC: {id: 'mBTC', text: 'mBTC', divider: '0.001 btc'}
  BTC: {id: 'BTC', text: 'BTC'}
  bits: {id: 'bits', text: 'bits', divider: '0.000001 btc' }

MainWalletController = Ember.Controller.extend(

  credentials: Ember.inject.service('cm-credentials')
  aa: Ember.inject.service('aa-provider')
  mm: Ember.inject.service('modals-manager')

  queryParams: ['new-account', 'tab']
  tab: null

  'new-account': false

  account: Ember.computed.alias('cm.currentAccount')
  modalManager: Ember.inject.service('modals-manager')

  credentialsBackup: false
  paring: false

  btcUnits: (->
    @get('cm.btcUnits').map( (e) ->
      return UNITS[e]
    )
  ).property('cm.btcUnits.[]')


  btcUnit: ( ->
    @get('btcUnits').findBy('id', @get('cm.btcUnit'))
  ).property('btcUnits', 'cm.btcUnit')


  openAccWizard: ( ->
    if @get('new-account')
      Ember.run.scheduleOnce 'afterRender', this, ->
        @get('modalManager').showModal('new-acct-wizard')
        @set('new-account', false)
  ).observes('new-account').on('init')

  dangerEnabled: false

  actions:

    reviewLicense: ->
      @get('mm').showModal('license')

    startPairing: ->
      @set 'pairing', true
      false

    donePairing: ->
      @set 'pairing', false

    changeLocale: (locl)->
      @set('cm.locale', locl)

    changeBtcUnit: (btcunit)->
      @set('cm.btcUnit', Ember.get(btcunit, 'id'))

    newAcctWizard: ->
      @get('modalManager').showModal('new-acct-wizard')

    doAcctJoinIn: ->
      @set 'acctJoinIn', true
      false

    doneAcctJoinIn: ->
      @set 'acctJoinIn', false

    doCredBackup: ->
      @set 'credentialsBackup', true
      false

    doneCredBackup: ->
      @set 'credentialsBackup', false


    doneNewAccount: (acct) ->
      Ember.run.scheduleOnce 'afterRender', this, ->
        @transitionToRoute('main.account.summary', Ember.get(acct, 'num'))


    toggleDanger: ->
      @toggleProperty('dangerEnabled')
      false

    deleteCredentials: ->
      cm = @get('cm')
      wallet = @get('currentWallet')

      cm.walletClose().then( (res) =>
        @get('credentials').reset()
        window.location.reload()
      )

    deleteAllDevices: ->
      api = @get('cm.api')

      op = (tfa) =>
        api.devicesDeleteAll(@get('credentials.deviceId'))

      @get('aa').tfaOrLocalPin(op, "Delete All Devices").then(() ->
        #
      ).catch((err) ->
        Ember.Logger.error 'Error deleting devices', err
      )




)

`export default MainWalletController`
