import Service, { inject as service } from '@ember/service'
import LeafModalsMgr from 'ember-leaf-core/services/leaf-modals-manager'
import { getWithDefault } from '@ember/object'

ModalsMgr = LeafModalsMgr.extend(

  i18n: service()

  showAlert: (data) ->
    i = @get('i18n')

    data.okLabel =  i.t(getWithDefault(data, 'okLabel', 'generic.ok'))
    data.cancelLabel =  i.t(getWithDefault(data, 'cancelLabel', 'generic.cancel'))

    data.title =  i.t(getWithDefault(data, 'title', 'generic.alert.title'))
    data.caption =  i.t(getWithDefault(data, 'caption', 'generic.alert.caption'))

    data.type ||= 'warning'

    @_super(data)
)

export default ModalsMgr
