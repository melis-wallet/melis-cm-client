import Controller from '@ember/controller'
import { schedule } from '@ember/runloop'

ApplicationController = Controller.extend(

  init: (->
    @_super()
    console.debug("FIX: init")
    schedule 'afterRender', this, (-> $(".preloading").remove())
  )
)

export default ApplicationController