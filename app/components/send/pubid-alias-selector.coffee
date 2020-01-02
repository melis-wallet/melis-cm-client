import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, readOnly } from '@ember/object/computed'
import { isEmpty, isBlank } from '@ember/utils'
import { get, set, getProperties } from '@ember/object'

import { validator, buildValidations } from 'ember-cp-validations'
import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'
import { task, taskGroup } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


Validations = buildValidations(
  newValue: [
    validator('presence', presence: true)
    validator('melis-pubid-alias')
  ]
)

CmSelector = Component.extend(Validations, ValidationsHelper,

  cm: service('cm-session')
  accounts: alias('cm.accounts')


  apiOps: taskGroup().drop()


  formError: readOnly('validations.attrs.newValue.message')
  infoError: null

  accountInfo: null

  selected: null
  newValue: null

  coin: null

  valuesChanged: (->
    @set('accountInfo', null)
  ).observes('newValue', 'selected')

  lookupInfo: task( ->
    @set('lookupError', false)
    if !isBlank(id = @get('newValue'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: id)
        Logger.debug('found:', res)
        if !(coin = @get('coin')) || (get(res, 'coin') == coin)
          @set('accountInfo', res)

      catch err
        if err.ex = 'CmInvalidAccountException'
          @setProperties
            accountInfo: null
            lookupError: 'Alias not found'
          @set('accountInfo', null)
        else
          Logger.error "Error: ", err
          @setProperties
            accountInfo: null
            lookupError: 'Generic error'

  ).group('apiOps')



  actions:
    lookupInfo: ->
      if @get('isValid')
        @get('lookupInfo').perform()

    confirmInfo: ->
      if info = @get('accountInfo')
        @sendAction('on-valid-value', getProperties(info, 'alias', 'pubId'))

    deleteValue: ->
      @sendAction('on-valid-value', null)


)

export default CmSelector


