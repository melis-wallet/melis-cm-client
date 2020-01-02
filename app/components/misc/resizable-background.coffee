import Component from '@ember/component'

ResizableBackground = Component.extend(
  image: null
  overlay: false

  setup: (->
     @.$().backstretch(@get('image'))
  ).on('didInsertElement')
)

export default ResizableBackground
