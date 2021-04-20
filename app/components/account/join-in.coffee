import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get } from '@ember/object'

import { validator, buildValidations } from 'ember-cp-validations'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

Validations = buildValidations(
  joinCode: [
    validator('presence', true)
    validator('length', is: 16)
  ]
)

JoinIn = Component.extend(Validations, 

  cm: service('cm-session')

  joinCode: null
  joinError: null
  invalidCode: false

  accountInfo: null
  accountName: null

  apiOps: taskGroup().drop()

  getJoinInfo: task((code) ->
    @setProperties
      joinError: null
      invalidCode: false
      accountInfo: null
      accountName: null

    try
      accountInfo = yield  @get('cm.api').joinCodeGetInfo(code)
      @set('accountInfo', accountInfo)
      Logger.debug accountInfo

      if (name = get(accountInfo, 'joinCode.masterPubMeta.name'))
        @set('accountName', name)
      else
        @set('accountName', @get('i18n').t('account.multi.join.default-name').toString())


    catch err
      Logger.error err
      if err.ex == 'CmInvalidJoinCodeException'
        @set('invalidCode', true)
      else
        @set('joinError', err.msg)


  ).group('apiOps')

  doJoin: task( (code) ->
    return unless code

    @setProperties
      joinError: null
      invalidCode: false


    name = @getWithDefault('accountName', @get('i18n').t('account.multi.join.default-name').toString())

    try
      account = yield  @get('cm').accountJoin(code: code, meta: {name: name})
      @sendAction('on-done', account)

    catch err
      Logger.error err
      if err.ex == 'CmInvalidJoinCodeException'
        @set('invalidCode', true)
      else
        @set('joinError', err.msg)

  ).group('apiOps')


  actions:
    cancelJoin: ->
      @sendAction('on-cancel')

    enterJoinCode: ->
      code = @get('joinCode')
      if code && @get('validations.isValid')
        @get('getJoinInfo').perform(code)

    doJoin: ->
      code = @get('accountInfo.joinCode.code')
      if code
        @get('doJoin').perform(code)
)

export default JoinIn