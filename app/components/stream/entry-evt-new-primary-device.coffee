import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


StreamEvt = Component.extend(

  cm: service('cm-session')
  clock: service('clock')

  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: alias('entry.content')
  label: alias('event.cmo.name')

  isThis: ( ->
    @get('event.cmo.ideviceId') == @get('cm.credentials.deviceId')
  ).property('event.cmo.deviceId', 'cm.credentials.deviceId')

  inFuture: ( ->
    @get('event.cmo.dateExecutable') > moment.now()
  ).property('event.cmo.dateExecutable', 'clock.minutes')

)

export default StreamEvt
