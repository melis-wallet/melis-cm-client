import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'

LABELS = ['initial']
INFO = 'Startup Widget'

StreamEvt = Component.extend(ModelFactory,

  cm: service('cm-session')
  service: service('cm-address-provider')

  classNames: ['row', 'animated', 'fadeIn']

  currentAddress: alias('service.current.currentAddress')

  setup: ( -> @get('service').ensureCurrent() ).on('init')
)


export default StreamEvt
