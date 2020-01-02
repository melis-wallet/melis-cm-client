import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


FingerPrintEnroll = Component.extend(

  cm: service('cm-session')
  fpa: service('fingerprint-auth')
  aaProvider: service('aa-provider')

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

export default FingerPrintEnroll
