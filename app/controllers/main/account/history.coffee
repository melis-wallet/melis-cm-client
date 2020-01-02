import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { isBlank } from '@ember/utils'
import { get, set, getWithDefault } from '@ember/object'

import { mergedProperty } from 'melis-cm-svcs/utils/misc'

import Logger from 'melis-cm-svcs/utils/logger'

MainHistoryController = Controller.extend(

  media: service('responsive-media')

  actions:
    toggleStar: (tx) ->
      if !isBlank(tx)
        api = @get('cm.api')
        value = !getWithDefault(tx, 'cmo.meta.starred', false)
        meta = mergedProperty(tx, 'cmo.meta', starred: value)
        api.txInfoSet(get(tx, 'cmo.id'), get(tx, 'cmo.labels'), meta).then( (res) =>

        ).catch((err) ->
          Logger.error "Failed setting info: ", err
        )

    selectTx: (tx) ->
      if tx
        @transitionToRoute('main.account.history.detail', @get('cm.currentAccount.pubId'), tx)
      else
        @transitionToRoute('main.account.history', @get('cm.currentAccount.pubId'))
)

export default MainHistoryController
