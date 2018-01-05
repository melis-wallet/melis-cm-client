`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

AddressesList = Ember.Component.extend(

  addresses: null
  cm: Ember.inject.service('cm-session')
  mm: Ember.inject.service('modals-manager')


  hasNext: null
  chkSignId: 'sign-msg-ck'
  doSignId: 'sign-msg'


  chkSignature: task(->
    try
      yield @get('mm').showModal(@get('chkSignId'))
    catch error
  )


  doSignature: task(->
    try
      yield @get('mm').showModal(@get('doSignId'))
    catch error
  )

  actions:
    selectAddr: (addr) ->
      @sendAction('on-select-addr', addr)

    nextPage: ->
      @sendAction('on-next-page')

    chkSignature: ->
      @get('chkSignature').perform()
      false

    doSignature: ->
      @get('doSignature').perform()
      false

)


`export default AddressesList`
