import Component from '@ember/component'
import { A } from '@ember/array'

import CMCore from 'melis-api-js'


SimpleAccSelector = Component.extend(


  accountType: CMCore.C.TYPE_2OF2_SERVER

  accountTypes: A([
    {id: CMCore.C.TYPE_2OF2_SERVER, label: '2of2'}
    {id: CMCore.C.TYPE_PLAIN_HD, label: 'plain'}
  ])

  onChange: ( ->
    if type = @get('accountType')
      @sendAction 'on-change-selected', type
  ).observes('accountType')
)

export default SimpleAccSelector
