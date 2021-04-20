import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { get, set, computed } from '@ember/object'
import RSVP from 'rsvp'

import Logger from 'melis-cm-svcs/utils/logger'
import { task, taskGroup } from 'ember-concurrency'
import FileSaverMixin from 'ember-cli-file-saver/mixins/file-saver';

AddressesList = Component.extend(FileSaverMixin,

  addresses: null
  cm: service('cm-session')
  mm: service('modals-manager')
  aa: service('aa-provider')

  showPublic: true
  showPrivate: true

  apiOps: taskGroup().drop()

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


  exportKeys: task((addr)->
    @set('exportData', null)
    account = @get('cm.currentAccount.cmo')
    api = @get('cm.api')

    key = (addr) =>
      return { address: addr, key: api.exportAddressKeyToWIF(account, addr) }
 
    op = (tfa) =>
      res = @get('addresses').map((a) => key(a))
      console.error(res)
      RSVP.resolve(res)

    try
      res = yield @get('aa').askLocalPin(op, 'Pin', '', true, true)
      if res
        console.log(JSON.stringify(res))
        this.saveFileAs('addresses.json', JSON.stringify(res), 'application/json')

    catch error
      Logger.error "Error: ", error
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

    exportKeys: ->
      @get('exportKeys').perform()
      false


)

export default AddressesList
