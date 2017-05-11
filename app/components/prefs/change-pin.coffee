`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

ChangePin = Ember.Component.extend(

  changing: false
  success: false
  error: false

  cm: Ember.inject.service('cm-session')
  aaProvider: Ember.inject.service('aa-provider')
  fpa: Ember.inject.service('fingerprint-auth')

  apiOps: taskGroup().drop()

  setNewPIN: task((newPin) ->
    @setProperties(success: false, error: false)

    try
      op = (data) =>
        @get('cm').changePin(data.pin, newPin)

      res = yield  @get('aaProvider').askLocalPin(op, 'Authorize Change Pin', true, true)
      if @get('fpa.successfullyEnrolled')
        try
          yield @get('fpa').enroll(newPin)
        catch e
          # the stored pin would not match
          @get('fpa').disable()


      @set('success', true)
      @set('changing', false)
    catch error
      @set('error', true)
      Ember.Logger.error('Set pin failed: ', error)

  ).group('apiOps')


  actions:
    toggleChange: ->
      @toggleProperty('changing')

    setNewPIN: (newPin) ->
      @get('setNewPIN').perform(newPin)

)

`export default ChangePin`
