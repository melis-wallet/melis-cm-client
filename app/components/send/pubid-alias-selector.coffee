`import Ember from 'ember'`
`import { validator, buildValidations } from 'ember-cp-validations'`
`import ValidationsHelper from 'ember-leaf-tools/mixins/ember-cp-validations-helper'`
`import { task, taskGroup } from 'ember-concurrency'`


Validations = buildValidations(
  newValue: [
    validator('presence', presence: true)
    validator('melis-pubid-alias')
  ]
)

CmSelector = Ember.Component.extend(Validations, ValidationsHelper,

  cm: Ember.inject.service('cm-session')
  accounts: Ember.computed.alias('cm.accounts')


  apiOps: taskGroup().drop()


  formError: Ember.computed.readOnly('validations.attrs.newValue.message')
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
    if !Ember.isBlank(id = @get('newValue'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: id)
        Ember.Logger.debug('found:', res)
        if !(coin = @get('coin')) || (Ember.get(res, 'coin') == coin)
          @set('accountInfo', res)

      catch err
        if err.ex = 'CmInvalidAccountException'
          @setProperties
            accountInfo: null
            lookupError: 'Alias not found'
          @set('accountInfo', null)
        else
          Ember.Logger.error "Error: ", err
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
        @sendAction('on-valid-value', Ember.getProperties(info, 'alias', 'pubId'))

    deleteValue: ->
      @sendAction('on-valid-value', null)


)

`export default CmSelector`


