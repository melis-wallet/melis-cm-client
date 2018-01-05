`import Ember from 'ember'`


FingerPrintEnroll = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  fpa: Ember.inject.service('fingerprint-auth')
  aaProvider: Ember.inject.service('aa-provider')

  setup: ( ->
    @get('fpa')
  ).on('init')


  doEnroll: ->
    op = (data) =>
      @get('fpa').enroll(data.pin)

    @get('aaProvider').askLocalPin(op, 'Authorize Pin', true, true)

  doRemove: ->
    @get('fpa').disable()

  actions:
    toggleFpa: (state) ->
      if state
        @doEnroll()
      else
        @doRemove()


)

`export default FingerPrintEnroll`
