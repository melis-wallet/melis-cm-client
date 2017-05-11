`import Ember from 'ember'`
`import CMCore from 'npm:melis-api-js'`

SimpleAccSelector = Ember.Component.extend(


  accountType: CMCore.C.TYPE_2OF2_SERVER

  accountTypes: Ember.A([
    {id: CMCore.C.TYPE_2OF2_SERVER, label: '2of2'}
    {id: CMCore.C.TYPE_PLAIN_HD, label: 'plain'}
  ])

  onChange: ( ->
    if type = @get('accountType')
      @sendAction 'on-change-selected', type
  ).observes('accountType')


)

`export default SimpleAccSelector`
