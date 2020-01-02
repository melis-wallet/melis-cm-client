import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get, set, computed } from '@ember/object'

import { task, taskGroup } from 'ember-concurrency'

AddressesList = Component.extend(

  addresses: null
  cm: service('cm-session')
  mm: service('modals-manager')

  showPublic: true
  showPrivate: true

  filteredAddresses: computed('addresses.@each.chain', 'showPrivate', 'showPublic', ->
    @get('addresses').filter((a) =>
      return true if @get('showPublic') && (get(a, 'chain') == 0)
      return true if @get('showPrivate') && (get(a, 'chain') == 1)
      false
    )
  )

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
    togglePublic: ->
      @toggleProperty('showPublic')

    togglePrivate: ->
      @toggleProperty('showPrivate')


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

export default AddressesList
