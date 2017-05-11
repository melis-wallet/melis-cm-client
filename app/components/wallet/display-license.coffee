`import Ember from 'ember'`

LICENSE_PATH = 'licenses'

DisplayLicense = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  'modal-id': 'license'

  notAcceptable: true
  displayOnly: false

  licenseFile: ( ->
    language = @get('i18n.locale')
    "#{LICENSE_PATH}/#{language}"
  ).property('i18n.locale')


  actions:
    enableAccept: ->
      @set 'notAcceptable', false

    disableAccept: ->
      @set 'notAcceptable', true


)

`export default DisplayLicense`
