import Component from '@ember/component'
import { inject as service } from '@ember/service'

ACCOUNT_TYPES = [
  { id: C.TYPE_PLAIN_HD, label: 'plain', canCreate: true }
  { id: C.TYPE_2OF2_SERVER, label: 'twooftwo', canCreate: true }
  { id: C.TYPE_MULTISIG_MANDATORY_SERVER, label: 'multisrv', canCreate: true }
  { id: C.TYPE_MULTISIG_NON_MANDATORY_SERVER, label: 'multi',  canCreate: false }
  { id: C.TYPE_MULTISIG_NO_SERVER, label: 'multisimp', canCreate: true }
  { id: C.TYPE_COSIGNER, label: 'cosigner', canCreate: false }
]


SelectAccountType = Component.extend(

  acct: service('cm-account-info')

  accountType: null
  accountTypes: ACCOUNT_TYPES.filterBy('canCreate', true)

)

export default SelectAccountType
