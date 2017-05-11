`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

CosignersStatus = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  acctInfo: Ember.inject.service('cm-account-info')

  account: Ember.computed.alias('cm.currentAccount')
  cosigners: Ember.computed.alias('cm.currentAccount.info.cosigners')
)
`export default CosignersStatus`