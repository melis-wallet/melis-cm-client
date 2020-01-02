import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { get } from '@ember/object'

EnrollController = Controller.extend(
  cm: service('cm-session')
  credentials: service('cm-credentials')


  connected: alias('cm.connected')
  disconnected: alias('cm.disconnected')
  connectFailed: alias('cm.connectFailed')


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

export default EnrollController
