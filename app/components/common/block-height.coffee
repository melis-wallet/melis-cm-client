`import Ember from 'ember'`

BlockHeight = Ember.Component.extend(

  value: Ember.computed.alias('tx.blockMature')
  threshold: 6
  cutoff: 9

  tagName: 'span'

  classNameBindings: ['heightClass']
  classNames: ['label']

  'always-show': false

  tx: null

  cm:  Ember.inject.service('cm-session')

  hide: false

  isCutoff: ( ->
    return false if @get('always-show')
    @get('height') > @get('cutoff')
  ).property('cutoff', 'height', 'always-show')


  height: (->
    if value = @get('value')
      (@get('cm.block.height') - value) + 1
    else
      0
  ).property('value', 'cm.block.height')

  heightClass: (->

    h = @get('height')
    switch
      when h == 0 then 'label-danger'
      when h < @get('threshold') then 'label-warning'
      else 'label-success'
  ).property('height')

)

`export default BlockHeight`
