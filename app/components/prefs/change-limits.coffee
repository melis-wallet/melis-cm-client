`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`
`import { task, timeout } from 'ember-concurrency'`

TIMELIMITS = [
  { name: 'daily', hours: 24 }
  { name: 'weekly', hours: 24*7 }
  { name: 'monthly', hours: 24*30 }
]

C = CMCore.C

ChangeLimits = Ember.Component.extend(

  # TODO FIXME validations are disabled!

  cm: Ember.inject.service('cm-session')
  aa: Ember.inject.service('aa-provider')
  coinsvc: Ember.inject.service('cm-coin')

  error: null

  spendableLimits: null
  changeRequests: null

  allSoftLimits: Ember.computed.filterBy('spendableLimits', 'isHard', false)
  allHardLimits: Ember.computed.filterBy('spendableLimits', 'isHard', true)

  allLimits: TIMELIMITS

  account: null

  parseLimits: (list) ->
    l = { daily: {}, weekly: {}, monthly: {} }
    list.forEach( (limit) ->
      if named = TIMELIMITS.findBy('hours', limit.hours)
        l[named.name] = limit
    )
    return l


  softLimits: ( ->
    @parseLimits(@get('allSoftLimits'))
  ).property('allSoftLimits.[]')

  hardLimits: ( ->
    @parseLimits(@get('allHardLimits'))
  ).property('allHardLimits.[]')

  changes: (->
    @parseLimits(@get('changeRequests'))
  ).property('changeRequests.[]')

  setup: (->
    @setProperties
      spendableLimits: Ember.A()
      changeRequests: Ember.A()
  ).on('init')


  accountChanged: ( ->
    @get('refreshLimits').perform()
  ).observes('account').on('init')


  updateLimit: (limit) ->
    limits = @get('spendableLimits')

    res = limits.find((target) ->
      target.hours == limit.hours &&
      target.isHard == target.isHard
    )

    if res
      limits.removeObject(res)
    if limit.limit != -1
      limits.pushObject(limit)


  updateChange: (limit) ->
    reqs = @get('changeRequests')
    res = reqs.find((target) ->
      target.hours == limit.hours &&
      target.isHard == target.isHard
    )
    if res
      reqs.removeObject(res)
    reqs.pushObject(limit)


  refreshLimits: task(() ->
    api = @get('cm.api')
    @set 'limits', @get('baseLimits')

    if account = @get('account.cmo')
      try
        data = yield api.accountGetLimits(account)
        console.log "--------------- limits"
        console.log data
        @setProperties
          spendableLimits: Ember.A(data.spendableLimits)
          changeRequests: Ember.A(data.changeRequests)
      catch error
        Ember.Logger.error 'Error getting limits: ',  error
  ).drop()

  setLimit: task((value, ident, isHard) ->
    api = @get('cm.api')

    @set('error', null)

    if Ember.isBlank(value)
      value = C.LIMIT_NONE
    else
      value = @get('coinsvc').parseUnit(@get('account'), value)

    account = @get('account.cmo')

    op = (tfa) ->
      value = -1 if Ember.isBlank(value)
      api.accountSetLimit(account, {type: ident, isHard: isHard, amount: value}, tfa.payload)

    try
      res = yield @get('aa').tfaOrLocalPin(op)
      if l = Ember.get(res, 'limitChangeRequest')
        if (l.dateExecutable && (l.dateExecutable > (l.dateRequested + 60000))) then @updateChange(l) else @updateLimit(l)
    catch error
      @set 'error', error
      Ember.Logger.error 'Error changing limit: ', error

  )


  setSoftLimit: (value, ident) ->
    @get('setLimit').perform(value, ident, false)


  setHardLimit: (value, ident)->
    @get('setLimit').perform(value, ident, true)

  actions:
    refreshLimits: ->
      @get('refreshLimits').perform()


    removeSoftLimit: (ident) ->
      @setSoftLimit(null, ident)

    removeHardLimit: (ident) ->
      @setHardLimit(null, ident)

    setSoftLimit: (value, ident)->
      @setSoftLimit(value, ident)

    setHardLimit: (value, ident)->
      @setHardLimit(value, ident)

)

`export default ChangeLimits`
