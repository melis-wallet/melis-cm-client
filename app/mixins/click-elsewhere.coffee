import Mixin from '@ember/object/mixin'
import { computed } from '@ember/object'
import { on as eon } from '@ember/object/evented'
import { bind } from '@ember/runloop'

ClickElsewhere = Mixin.create

 #use this method hook to define your desired behavior
  onClickElsewhere: Ember.K

  #bound version of our instance method
  clickHandler: computed ->
    bind @, 'onClickElsewhere'

  #logic for determining of a click has landed anywhere but our view
  elsewhereHandler: (e) ->
    element = @get "element"
    $target = $ e.target
    thisIsElement = $target.closest(element).length is 1
    unless thisIsElement then @onClickElsewhere event

  #attach event listener to window when view in DOM
  setupClickEvent: eon 'didInsertElement', ->
    $(window).on "click", @get "clickHandler"

  #remove window event listener when view removed from DOM
  teardownClickEvent: eon 'willDestroyElement', ->
    $(window).off "click", @get "clickHandler"


export default ClickElsewhere
