`import Ember from 'ember'`

MainReceiveController = Ember.Controller.extend(
  service: Ember.inject.service('cm-address-provider')

  # Query params for redrect payment
  queryParams: ['active']

  currentCode: null
  activeCode: null


  showActive: Ember.computed.notEmpty('activeCode')

  showCurrent: ( ->
    Ember.isNone(@get('activeCode')) && @get('currentCode')
  ).property('activeCode', 'currentCode')


  actions:
    changedActiveCode: (code)->
      @set('activeCode', code)

    changedCurrentCode: (code)->
      @set('currentCode', code)

    setActive: (addr) ->
      @set('activeAddress', addr)


)

`export default MainReceiveController`
