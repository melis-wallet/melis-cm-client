`import Ember from 'ember'`

BackButton = Ember.Mixin.create(

  device: Ember.inject.service('device-support')

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

`export default BackButton`
