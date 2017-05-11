`import Ember from 'ember'`

ClickElsewhere = Ember.Mixin.create

 #use this method hook to define your desired behavior
  onClickElsewhere: Ember.K

  #bound version of our instance method
  clickHandler: Em.computed ->
    Ember.run.bind @, 'onClickElsewhere'

  #logic for determining of a click has landed anywhere but our view
  elsewhereHandler: (e) ->
    element = @get "element"
    $target = $ e.target
    thisIsElement = $target.closest(element).length is 1
    unless thisIsElement then @onClickElsewhere event

  #attach event listener to window when view in DOM
  setupClickEvent: Ember.on 'didInsertElement', ->
    $(window).on "click", @get "clickHandler"

  #remove window event listener when view removed from DOM
  teardownClickEvent: Ember.on 'willDestroyElement', ->
    $(window).off "click", @get "clickHandler"


`export default ClickElsewhere`
