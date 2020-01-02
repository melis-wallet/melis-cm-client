import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, sort } from '@ember/object/computed'
import { get } from '@ember/object'
import { isBlank } from '@ember/utils'

import { task } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'

DiscussionMini = Component.extend(

  cm: service('cm-session')
  ptxsvc: service('cm-ptxs')
  tx: null

  view: 'detailed'
  input: true

  last: 3
  animate: true

  messages: alias('tx.discussion')
  newMessage: null

  messagesSorting: ['date:asc']
  messagesSorted: sort('messages', 'messagesSorting')

  lastMessages: ( ->
    if @get('animate')
      @get('messagesSorted').slice(-(@get('last')), -1)
    else
      @get('messagesSorted').slice(-(@get('last')))
  ).property('messagesSorted')
  lastMessage: alias('messagesSorted.lastObject')


  txChanged: ( ->
    @set('newMessage', null)
    @get('ptxsvc').fetchDiscussion(@get('tx'))
  ).observes('tx').on('init')

  sendMessage: task((tx, msg) ->
    account = get(tx, 'account.cmo')
    if tx && !isBlank(msg)
      try
        yield @get('cm.api').msgSendToPtx(account, tx.get('cmo'), {plaintext: msg})
        @set('newMessage', null)
      catch error
        Logger.error "Error in send to ptx:", error
  ).enqueue()

  refreshDiscussion: ->
    Logger.debug "Refreshing discussion"
    if tx = @get('tx')
      get('ptxsvc').fetchDiscussion(tx)

  setup: (->
    @get('cm').on('net-restored', this, @refreshDiscussion)
  ).on('init')

  tearDown: ( ->
    @get('cm').off('net-restored', this, @refreshDiscussion)
  ).on('willDestroyElement')


  actions:
    enterMessage: ->
      { tx, newMessage } = @getProperties('tx', 'newMessage')
      @get('sendMessage').perform(tx, newMessage)

)

export default DiscussionMini
