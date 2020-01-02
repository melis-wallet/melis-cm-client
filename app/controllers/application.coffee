import Controller from '@ember/controller'
import { schedule } from '@ember/runloop'

ApplicationController = Controller.extend(

  removeSpinner: (->
    schedule 'afterRender', this, (-> $(".preloading").remove())
  ).on('init')
)

export default ApplicationController