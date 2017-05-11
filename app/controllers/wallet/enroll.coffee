`import Ember from 'ember'`


EnrollController = Ember.Controller.extend(
  cm: Ember.inject.service('cm-session')
  credentials: Ember.inject.service('cm-credentials')


  connected: Ember.computed.alias('cm.connected')
  disconnected: Ember.computed.alias('cm.disconnected')
  connectFailed: Ember.computed.alias('cm.connectFailed')


  licenseAccepted: false

  acceptLicense: ->
    @set('licenseAccepted', true)

  rejectLicense: ->
    @set('licenseAccepted', false)
    @transitionToRoute('index')

  actions:
    handleLicenseReply: (value) ->
      if value == 'ok'
        @acceptLicense()
      else
        @rejectLicense()
      false

    rejectLicense: (value) ->
      @rejectLicense()
      false

    abortWizard: (-> @transitionToRoute('wallet.welcome'))



)
`export default EnrollController`
