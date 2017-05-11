`import Ember from 'ember'`
`import { task } from 'ember-concurrency'`

DiscussionMini = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  ptxsvc: Ember.inject.service('cm-ptxs')
  tx: null

  view: 'detailed'
  input: true

  last: 3
  animate: true

  messages: Ember.computed.alias('tx.discussion')
  newMessage: null

  messagesSorting: ['date:asc']
  messagesSorted: Ember.computed.sort('messages', 'messagesSorting')

  lastMessages: ( ->
    if @get('animate')
      @get('messagesSorted').slice(-(@get('last')), -1)
    else
      @get('messagesSorted').slice(-(@get('last')))
  ).property('messagesSorted')
  lastMessage: Ember.computed.alias('messagesSorted.lastObject')


  txChanged: ( ->
    @set('newMessage', null)
    @get('ptxsvc').fetchDiscussion(@get('tx'))
  ).observes('tx').on('init')

  sendMessage: task((tx, msg) ->
    account = Ember.get(tx, 'account.cmo')
    if tx && !Ember.isBlank(msg)
      try
        yield @get('cm.api').msgSendToPtx(account, tx.get('cmo'), {plaintext: msg})
        @set('newMessage', null)
      catch error
        Ember.Logger.error "Error in send to ptx:", error
  ).enqueue()

  refreshDiscussion: ->
    Ember.Logger.debug "Refreshing discussion"
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

`export default DiscussionMini`
