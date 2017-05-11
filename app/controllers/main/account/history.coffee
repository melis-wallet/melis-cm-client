`import Ember from 'ember'`
`import { mergedProperty } from 'melis-cm-svcs/utils/misc'`

MainHistoryController = Ember.Controller.extend(

  media: Ember.inject.service('responsive-media')


  actions:
    toggleStar: (tx) ->
      if !Ember.isBlank(tx)
        api = @get('cm.api')
        value = !Ember.getWithDefault(tx, 'cmo.meta.starred', false)
        meta = mergedProperty(tx, 'cmo.meta', starred: value)
        api.txInfoSet(Ember.get(tx, 'cmo.id'), Ember.get(tx, 'cmo.labels'), meta).then( (res) =>

        ).catch((err) ->
          console.error "Failed setting info: ", err
        )

    selectTx: (tx) ->
      if tx
        @set('activeModel', tx)
        @transitionToRoute('main.account.history.detail', @get('cm.currentAccount.num'), tx)
      else
        @set('activeModel', null)
        @transitionToRoute('main.account.history', @get('cm.currentAccount.num'))

)

`export default MainHistoryController`
