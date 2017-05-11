`import Ember from 'ember'`

StreamHwm = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  stream: Ember.inject.service('cm-stream')
  wallet: Ember.inject.service('cm-wallet')
  classNames: ['row', 'animated', 'fadeIn']


  mystream: ( ->
    @get('entry.account.stream')  || @get('wallet.stream')
  ).property('entry.account')

  newCount: Ember.computed.alias('mystream.newer.length')
  show: Ember.computed.notEmpty('mystream.newer')


  actions:
    showNew: ->
      if account = @get('entry.account')
        @get('stream').setLowWater(account, @get('entry.updated'), account)
        @get('stream').setHighWater(account, moment.now(), account)
      else
        @get('stream').setLowWater(@get('wallet'), @get('entry.updated'))
        @get('stream').setHighWater(@get('wallet'), moment.now())


)


`export default StreamHwm`
