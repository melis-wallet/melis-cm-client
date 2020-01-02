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

  inFuture: ( ->
    @get('event.cmo.dateExecutable') > moment.now()
  ).property('event.cmo.dateExecutable', 'clock.minutes')

)

export default StreamEvt
