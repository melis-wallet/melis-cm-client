`import Ember from 'ember'`

MoreInfo = Ember.Component.extend(

  prompt: null
  displayed: false
  classNames: ['padding-sm-vr']


  actions:
    displayOn: ->
      @sendAction('on-open')
      @set('displayed', true)

    displayOff: ->
      @sendAction('on-close')
      @set('displayed', false)
)


`export default MoreInfo`