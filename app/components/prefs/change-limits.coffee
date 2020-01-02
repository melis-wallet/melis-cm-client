import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { filterBy } from '@ember/object/computed'
import { get, set, setProperties } from '@ember/object'
import { A } from '@ember/array'
import { isBlank } from '@ember/utils'

import CMCore from 'npm:melis-api-js'
import { task, timeout } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

TIMELIMITS = [
  { name: 'daily', hours: 24 }
  { name: 'weekly', hours: 24*7 }
  { name: 'monthly', hours: 24*30 }
]

C = CMCore.C

ChangeLimits = Component.extend(

  # TODO FIXME validations are disabled!

  cm: service('cm-session')
  aa: service('aa-provider')
  coinsvc: service('cm-coin')

  error: null

  spendableLimits: null
  changeRequests: null

  allSoftLimits: filterBy('spendableLimits', 'isHard', false)
  allHardLimits: filterBy('spendableLimits', 'isHard', true)

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
      spendableLimits: A()
      changeRequests: A()
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
          spendableLimits: A(data.spendableLimits)
          changeRequests: A(data.changeRequests)
      catch error
        Logger.error 'Error getting limits: ',  error
  ).drop()

  setLimit: task((value, ident, isHard) ->
    api = @get('cm.api')

    @set('error', null)

    if isBlank(value)
      value = C.LIMIT_NONE
    else
      value = @get('coinsvc').parseUnit(@get('account'), value)

    account = @get('account.cmo')

    op = (tfa) ->
      value = -1 if isBlank(value)
      api.accountSetLimit(account, {type: ident, isHard: isHard, amount: value}, tfa.payload)

    try
      res = yield @get('aa').tfaOrLocalPin(op)
      if l = get(res, 'limitChangeRequest')
        if (l.dateExecutable && (l.dateExecutable > (l.dateRequested + 60000))) then @updateChange(l) else @updateLimit(l)
    catch error
      @set 'error', error
      Logger.error 'Error changing limit: ', error

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

export default ChangeLimits
