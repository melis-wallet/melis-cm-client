import Component from '@ember/component'
import { inject as service } from '@ember/service'

CUTOFF = 7*24*6

BlockExpire = Component.extend(

  tagName: 'span'
  classNames: ['label']
  classNameBindings: ['labelClass']

  cm: service('cm-session')
  value: null

  expired: (->
    if value = @get('value')
      value < @get('cm.block.height')
  ).property('value', 'cm.block.height')

  expiring: (->
    if (value = @get('value'))
      (value >= @get('cm.block.height'))
      ((value - @get('cm.block.height')) < CUTOFF)
  ).property('value', 'cm.block.height')

  labelClass: (->
    if @get('expired') then return 'label-danger'
    if @get('expiring') then return 'label-warning'
  ).property('expired', 'expiring')
)

export default BlockExpire
