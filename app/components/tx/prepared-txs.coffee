`import Ember from 'ember'`
`import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'`
`import Alertable from 'ember-leaf-core/mixins/leaf-alertable'`

PreparedTxs = Ember.Component.extend(Alertable, SlyEnabled,

  selectedTx: null
  currentTx: null

  shown: Ember.computed.notEmpty('preparedTxs')

  cm: Ember.inject.service('cm-session')

  detail: false

  preparedTxs: Ember.computed.alias('cm.currentAccount.ptxs.relevant')

  notifySly: ( ->
    if @get('preparedTxs.length')
      @slyContentChanged()
  ).observes('preparedTxs.[]', 'shown')

  actions:
    selectTx: (tx) ->
      if @get('selectedTx') == tx
        # @set 'selectedTx', null
        # @sendAction('on-select-ptx', null)
      else
        @set 'selectedTx', tx
        @sendAction('on-select-ptx', tx)

    deleteSelectedTx: ->
      if tx = @get('selectedTx')
        api = @get('cm.api')
        api.ptxCancel(tx).then( =>
          @set('selectedTx', null)
        )
        @sendAction('on-delete-tx', tx)

    resumeSelectedTx: ->
      if tx = @get('selectedTx')
        @set('selectedTx', null)
        @sendAction('on-resume-tx', tx.get('cmo'))

)

`export default PreparedTxs`
