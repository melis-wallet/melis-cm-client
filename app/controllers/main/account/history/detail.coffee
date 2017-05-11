`import Ember from 'ember'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`

MainHistoryDetailController = Ember.Controller.extend(

  historyCtrl: Ember.inject.controller('main.account.history')

  actions:
    changeTxLabels: (labels, tx) ->
      api = @get('cm.api')
      api.txInfoSet(tx.id, labels, tx.meta).then( (res)=>
        @set 'selected', res
      ).catch((err) ->
        console.error "Failed setting info: ", err
      )

    changeTxInfo: (value, tx) ->
      if !Ember.isBlank(tx)
        api = @get('cm.api')
        meta = mergedProperty(tx, 'cmo.meta', info: value)
        api.txInfoSet(Ember.get(tx, 'cmo.id'), Ember.get(tx, 'cmo.labels'), meta).then( (res)=>
          @set 'selected', res
        ).catch((err) ->
          console.error "Failed setting info: ", err
        )
)

`export default MainHistoryDetailController`
