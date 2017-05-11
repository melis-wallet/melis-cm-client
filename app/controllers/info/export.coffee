`import Ember from 'ember'`

InfoExportController = Ember.Controller.extend(

  app_state: Ember.inject.service('app-state')

  exportedGeneratorQR:  Ember.computed.alias('app_state.exportedGeneratorQR')
  exportedMnemonic:  Ember.computed.alias('app_state.exportedMnemonic')

  includeFancy: true

)

`export default InfoExportController`
