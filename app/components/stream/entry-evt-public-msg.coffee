import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


StreamEvt = Component.extend(

  cm: service('cm-session')
  entry: null

  classNames: ['stream-entry', 'row', 'animated', 'fadeIn']

  event: alias('entry.content')

  name: alias('event.account.cmo.meta.name')
  code: alias('event.cmo.activationCode')

)

export default StreamEvt
