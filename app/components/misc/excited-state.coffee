import Component from '@ember/component'

import { task } from 'ember-concurrency'
import { waitTime, waitIdle, waitIdleTime } from 'melis-cm-svcs/utils/delayed-runners'

ExcitedState = Component.extend(

  tagName: 'span'
  excited: false
  guarding: false

  guard: 500
  hold: 2000

  excite: task( ->
    if !@get('excited') && !@get('guarding')
      @setProperties
        guarding: true
        excited: false
      yield waitTime(@get('guard'))
      @setProperties
        guarding: false
        excited: true
      yield waitTime(@get('hold'))
      @setProperties
        guarding: false
        excited: false
  )

  actions:
    excite: ->
      @get('excite').perform()

)


export default ExcitedState