import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import { task, timeout } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

Validations = buildValidations(
  newAlias: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
    validator('format', regex: /^\w+$/, message: 'must be letters, numbers and underscore (_), only')
    validator('unique-alias', debounce: 500)
  ]

)

ChangeAccountAlias = Component.extend(Validations, ValidationsHelper,

  cm: service('cm-session')

  aliasInfo: null
  newAlias: null


  canSubmit: alias('isValid')

  changeAlias: task((newAlias) ->
    api = @get('cm.api')
    account = @get('cm.currentAccount.cmo')

    try
      data = yield api.aliasDefine(account, newAlias)
      @set('cm.currentAccount.cmo.alias', newAlias)
      @set('changingAlias', false)
    catch error
      Logger.error "Error changing alias: ",  error
  )

  getUpdatedInfo: task( ->
    api = @get('cm.api')
    if account = @get('cm.currentAccount.cmo')
      try
        data = yield api.aliasGetInfo(account)
        @set('aliasInfo', data)
      catch error
        Logger.error "Error getting alias-info: ",  error
  ).drop()


  setup: ( ->
    @get('getUpdatedInfo').perform()
  ).observes('cm.currentAccount.cmo.alias').on('init')

  actions:
    changeAlias: ->
      @toggleProperty('changingAlias')

    submit: ->
      # do nothing, i want the user to hit the button

    confirmAliasChange: ->
      if (newAlias = @get('newAlias')) && @get('canSubmit')
        @get('changeAlias').perform(newAlias)

)

export default ChangeAccountAlias
