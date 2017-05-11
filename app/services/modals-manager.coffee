`import CMCore from 'npm:melis-api-js'`
`import LeafModalsMgr from 'ember-leaf-core/services/leaf-modals-manager'`

C = CMCore.C

ModalsMgr = LeafModalsMgr.extend(

  i18n: Ember.inject.service()

  showAlert: (data) ->
    i = @get('i18n')

    data.okLabel =  i.t(Ember.getWithDefault(data, 'okLabel', 'generic.ok'))
    data.cancelLabel =  i.t(Ember.getWithDefault(data, 'cancelLabel', 'generic.cancel'))

    data.title =  i.t(Ember.getWithDefault(data, 'title', 'generic.alert.title'))
    data.caption =  i.t(Ember.getWithDefault(data, 'caption', 'generic.alert.caption'))

    data.type ||= 'warning'


    @_super(data)

)

`export default ModalsMgr`
