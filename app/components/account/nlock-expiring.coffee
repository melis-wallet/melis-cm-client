`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import { task, taskGroup } from 'ember-concurrency'`


NlockExpiring = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  recovery: Ember.inject.service('cm-recovery-info')
  aaProvider: Ember.inject.service('aa-provider')
  ptxsvc: Ember.inject.service('cm-ptxs')

  account: null
  unspents: null
  error: false

  validUnspents: Ember.computed.filter('unspents', ((i) ->
    (i.blockMature > 0) &&
    (i.timeExpire < moment().add(1, 'week').valueOf())
  ))

  checkedUnspents: Ember.computed.filterBy('validUnspents', 'checked', true)

  activeUnspents: ( ->
    if Ember.isEmpty(@get('checkedUnspents')) then @get('validUnspents') else @get('checkedUnspents')
  ).property('validUnspents', 'checkedUnspents')

  preparedTx: null
  doneTx: null


  apiOps: taskGroup().drop()

  confirmRotation: task( (tx) ->
    @setProperties
      error: false
      doneTx: false

    try
      res = yield @get('ptxsvc').ptxSign(tx)
      @setProperties
        error: false
        preparedTx: null
        doneTx: true
    catch error
      @set('error', true)
      Ember.Logger.error "Error signing: ", error

  )


  cancelRotation: task( (tx) ->
    @setProperties
      error: false
      doneTx: false

    try
      res = yield @get('ptxsvc').ptxCancel(tx)
      @setProperties
        error: false
        preparedTx: null
        doneTx: null
    catch error
      @set('error', true)
      Ember.Logger.error "Error cancelling: ", error

  )


  rotateInputs: task( (inputs) ->
    @setProperties
      error: false
      doneTx: false

    return if Ember.isEmpty(inputs)
    if (account = @get('account'))
      unspents = inputs.map((i) -> {hash: i.tx, n: i.n })

      try
        state = yield @get('cm.api').payPrepare(account.get('cmo'), [{pubId: @get('account.uniqueId'), amount: 0, isRemainder: true}], autoSignIfValidated: true, disableRbf: true, unspents: unspents)
        ptx = @get('ptxsvc').ptxFromState(state, @get('account'))
        @set 'preparedTx', ptx

      catch error
        @set('error', true)
        Ember.Logger.error "Error rotating: ", error

  ).group('apiOps')


  refresh: task( ->
    return unless (acc = @get('account'))
    try
      yield @get('recovery').getExpiringUnspents(acc)
    catch error
      Ember.Logger.error "Error refresh: ", error
  )

  actions:
    refresh: ->
      @get('refresh').perform()

    rotateAll: (inputs) ->
      @get('rotateInputs').perform(inputs)


    confirmRotation: ->
      if (tx = @get('preparedTx'))
        @get('confirmRotation').perform(tx)

    cancelRotation: ->
      if (tx = @get('preparedTx'))
        @get('cancelRotation').perform(tx)

    clearDone: ->
      console.error 'clearDone'
      @set('doneTx', false)

)
`export default NlockExpiring`