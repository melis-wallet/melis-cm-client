import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

MainStreamView = Component.extend(

  cm: service('cm-session')
  svc: service('cm-stream')

  inited: alias('svc.inited')
  streamEntries: alias('account.stream.current')

  account: null

  classNames: ['stream']

  actions:
    goto: (id) ->
      @sendAction('onmoveto', id)

)

export default MainStreamView
