`import Ember from 'ember'`

MainPtxDetailController = Ember.Controller.extend(

  index: Ember.inject.controller('main.account.ptx')

  modelChanged: (->
    @set('index.activePtx', @get('model'))
  ).observes('model')
)

`export default MainPtxDetailController`
