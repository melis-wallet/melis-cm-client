import Mixin from '@ember/object/mixin'
import { inject as service } from '@ember/service'

BackButton = Mixin.create(

  device: service('device-support')

  #
  onBack: ( -> @sendAction('on-backbutton', this) )
  #
  _setupEvents: ( ->
    @get('device').on('backbutton', this, @onBack)
  ).on('didInsertElement')

  #
  _tearoffEvents: ( ->
    @get('device').off('backbutton', this, @onBack)
  ).on('willDestroyElement')
)

export default BackButton
