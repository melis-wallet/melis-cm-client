`import Ember from 'ember'`


LinkAction = Ember.Mixin.create(


  init: ->
    @._super(arguments...)

    if @get('before-action')
      @_attachActionEvent()


  willDestroyElement: ->
    if @get('before-action')
      @_detachActionEvent()


  _sendBeforeAction: ->
    @sendAction('before-action')


  _attachActionEvent: ->
    @on(@get('eventName'), this, @_sendBeforeAction)



  _detachActionEvent: ->
    @off(@get('eventName'), this, @_sendBeforeAction)

)

`export default LinkAction`
