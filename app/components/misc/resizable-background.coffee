`import Ember from 'ember'`

ResizableBackground = Ember.Component.extend(
  image: null
  overlay: false

  setup: (->
     @.$().backstretch(@get('image'))
  ).on('didInsertElement')

)

`export default ResizableBackground`
