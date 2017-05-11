`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend(


  removeSpinner: (->
    Ember.run.schedule 'afterRender', this, (->
      $(".preloading").remove()
    )
  ).on('init')
)

`export default ApplicationController`