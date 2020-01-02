import Controller, { inject as controller } from '@ember/controller'

MainPtxDetailController = Controller.extend(

  index: controller('main.account.ptx')

  modelChanged: (-> @set('index.activePtx', @get('model'))).observes('model')
)

export default MainPtxDetailController
