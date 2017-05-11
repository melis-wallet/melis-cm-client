`import Ember from 'ember'`
`import { task } from 'ember-concurrency'`
`import SlyEnabled from 'ember-leaf-tools/mixins/sly-enabled'`

PreparedTx = Ember.Component.extend(SlyEnabled,

  cm: Ember.inject.service('cm-session')
  ptxsvc: Ember.inject.service('cm-ptxs')

  tx: null

  view: 'detailed'
  input: true

  messages: Ember.computed.alias('tx.discussion')
  newMessage: null

  messagesSorting: ['date:asc']
  messagesSorted: Ember.computed.sort('messages', 'messagesSorting')

  lastMessage: Ember.computed.alias('messagesSorted.lastObject')

  'follow-bottom': true

  txChanged: ( ->
    @set('newMessage', null)
    @get('ptxsvc').fetchDiscussion(@get('tx'))
  ).observes('tx').on('init')

  notifySly: ( ->
    if @get('messages.length')
      @slyContentChanged()
  ).observes('messages.[]')

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

`export default PreparedTx`
