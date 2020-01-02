import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'

PubidToName = Helper.extend(

  cm: service('cm-session')


  compute: (params, hash) ->
    pubid = params[0]

    cA =
      if hash.account
        hash.account
      else
        @get('cm.currentAccount')

    return pubid unless cA

    if cosigners = cA.get('info.cosigners')
      if z = cosigners.findBy('pubId', pubid)
        z.name
      else
        pubid
    else
      pubid
)

export default PubidToName