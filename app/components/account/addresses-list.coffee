`import Ember from 'ember'`

AddressesList = Ember.Component.extend(

  addresses: null
  cm: Ember.inject.service('cm-session')

  hasNext: null

  actions:
    selectAddr: (addr) ->
      @sendAction('on-select-addr', addr)


    nextPage: ->
      @sendAction('on-next-page')

)

`export default AddressesList`
