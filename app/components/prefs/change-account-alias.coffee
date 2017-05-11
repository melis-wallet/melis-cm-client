`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, timeout } from 'ember-concurrency'`

Validations = buildValidations(
  newAlias: [
    validator('presence', true)
    validator('length', min: 4, max: 32)
    validator('format', regex: /^\w+$/, message: 'must be letters, numbers and underscore (_), only')
    validator('unique-alias', debounce: 500)
  ]

)

ChangeAccountAlias = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')

  aliasInfo: null
  newAlias: null


  canSubmit:Ember.computed.alias('isValid')

  changeAlias: task((newAlias) ->
    api = @get('cm.api')
    account = @get('cm.currentAccount.cmo')

    try
      data = yield api.aliasDefine(account, newAlias)
      @set('cm.currentAccount.cmo.alias', newAlias)
      @set('changingAlias', false)
    catch error
      Ember.Logger.error "Error changing alias: ",  error
  )

  getUpdatedInfo: task( ->
    api = @get('cm.api')
    if account = @get('cm.currentAccount.cmo')
      try
        data = yield api.aliasGetInfo(account)
        @set('aliasInfo', data)
      catch error
        Ember.Logger.error "Error getting alias-info: ",  error
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

`export default ChangeAccountAlias`
