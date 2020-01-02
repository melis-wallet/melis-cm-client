import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'


AliasToName = Helper.extend(

  cm: service('cm-session')

  compute: (params, hash) ->
    cmalias = params[0]

    cA =
      if hash.account
        hash.account
      else
        @get('cm.currentAccount')

    return cmalias unless cA

    if cosigners = cA.get('info.cosigners')
      if z = cosigners.findBy('alias', alias)
        z.name
      else
        cmalias
    else
      cmalias

)

export default AliasToName