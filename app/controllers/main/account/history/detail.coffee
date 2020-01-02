import Controller, { inject as controller } from '@ember/controller'
import { get, set } from '@ember/object'
import { isEmpty, isBlank } from '@ember/utils'

import { mergedProperty } from 'melis-cm-svcs/utils/misc'

import Logger from 'melis-cm-svcs/utils/logger'


MainHistoryDetailController = Controller.extend(

  historyCtrl: controller('main.account.history')

  modelChanged: ( ->
    @set('historyCtrl.activeModel', @get('model'))

  ).observes('model')

  actions:
    changeTxLabels: (labels, tx) ->
      api = @get('cm.api')
      api.txInfoSet(tx.id, labels, tx.meta).then( (res)=>
        @set 'selected', res
      ).catch((err) ->
        Logger.error "Failed setting info: ", err
      )

    changeTxInfo: (value, tx) ->
      if !isBlank(tx)
        api = @get('cm.api')
        meta = mergedProperty(tx, 'cmo.meta', info: value)
        api.txInfoSet(get(tx, 'cmo.id'), get(tx, 'cmo.labels'), meta).then( (res)=>
          @set 'selected', res
        ).catch((err) ->
          Logger.error "Failed setting info: ", err
        )
)

export default MainHistoryDetailController
