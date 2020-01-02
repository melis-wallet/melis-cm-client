import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

EnrollController = Controller.extend(
  credentials: service('cm-credentials')
)

export default EnrollController
