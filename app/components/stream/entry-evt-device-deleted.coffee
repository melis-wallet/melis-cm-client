import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty, equal } from '@ember/object/computed'

StreamEvt = Component.extend(

  cm: service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: alias('entry.content')

  label: ( ->
    @get('event.cmo.name') || @get('event.cmo.id')
  ).property('event.cmo.name', 'event.cmo.id')

  shouldShow: notEmpty('event.cmo.lastUsedInLogin')

)

export default StreamEvt
