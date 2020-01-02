import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

CosignersStatus = Component.extend(

  cm: service('cm-session')
  acctInfo: service('cm-account-info')

  account: alias('cm.currentAccount')
  cosigners: alias('cm.currentAccount.info.cosigners')
)

export default CosignersStatus