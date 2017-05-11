`import Ember from 'ember'`
`import ModelFactory from 'melis-cm-svcs/mixins/simple-model-factory'`

LABELS = ['initial']
INFO = 'Startup Widget'

StreamEvt = Ember.Component.extend(ModelFactory,

  cm: Ember.inject.service('cm-session')
  classNames: ['row', 'animated', 'fadeIn']

  service: Ember.inject.service('cm-address-provider')
  currentAddress: Ember.computed.alias('service.current.currentAddress')


  setup: ( -> @get('service').ensureCurrent() ).on('init')
)


`export default StreamEvt`
