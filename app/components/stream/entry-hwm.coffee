import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias, notEmpty } from '@ember/object/computed'


StreamHwm = Component.extend(

  cm: service('cm-session')
  stream: service('cm-stream')
  wallet: service('cm-wallet')
  classNames: ['row', 'animated', 'fadeIn']

  mystream: ( ->
    @get('entry.account.stream')  || @get('wallet.stream')
  ).property('entry.account')

  newCount: alias('mystream.newer.length')
  show: notEmpty('mystream.newer')

  warnOutdated: alias('cm.outdatedClient')

  actions:
    showNew: ->
      if account = @get('entry.account')
        @get('stream').setLowWater(account, @get('entry.updated'), account)
        @get('stream').setHighWater(account, moment.now(), account)
      else
        @get('stream').setLowWater(@get('wallet'), @get('entry.updated'))
        @get('stream').setHighWater(@get('wallet'), moment.now())
)

export default StreamHwm
