import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'
import { get, set } from '@ember/object'

BlockHeight = Component.extend(

  coinsvc: service('cm-coin')
  cm: service('cm-session')

  value: alias('etx.blockMature')
  threshold: 6
  cutoff: 9

  tagName: 'span'

  classNameBindings: ['heightClass']
  classNames: ['label']

  'always-show': false

  tx: null
  account: null

  etx: ( ->
    if (tx = @get('tx')) && (cmo = get(tx, 'cmo')) then cmo else tx
  ).property('tx', 'tx.cmo')

  coin: ( ->
    account = if (a = @get('tx.account')) then a else @get('account')
    account?.get('coin')
  ).property('tx.account', 'account')

  unit: ( ->
    @get('coinsvc.coins')?.findBy('unit', @get('coin'))
  ).property('coin')

  block: alias('unit.block')


  hide: false

  isCutoff: ( ->
    return false if @get('always-show')
    @get('height') > @get('cutoff')
  ).property('cutoff', 'height', 'always-show')


  height: (->
    if value = @get('value')
      (@get('block.height') - value) + 1
    else
      0
  ).property('value', 'block.height')

  heightClass: (->

    h = @get('height')
    switch
      when h == 0 then 'label-danger'
      when h < @get('threshold') then 'label-warning'
      else 'label-success'
  ).property('height')

)

export default BlockHeight
