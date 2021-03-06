import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'

CoSigner = Helper.extend(

  cm: service('cm-session')

  compute: (params, hash) ->
    id = params[0]

    cA = hash.account || @get('cm.currentAccount')

    return id unless cA
    cA.cosignerName(id, {you: hash.you, idIsFine: true})
)

export default CoSigner