import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'


WalletStreamView = Component.extend(

  cm: service('cm-session')
  svc: service('cm-stream')
  walletsvc: service('cm-wallet')

  inited: alias('svc.inited')
  streamEntries: alias('walletsvc.stream.current')

  classNames: ['stream']

  actions:
    goto: (id) ->
      @sendAction('onmoveto', id)

)

export default WalletStreamView
