import Controller from '@ember/controller'
import { inject as service } from '@ember/service'
import { notEmpty } from '@ember/object/computed'
import { isNone } from '@ember/utils'

MainReceiveController = Controller.extend(
  service: service('cm-address-provider')

  # Query params for redrect payment
  queryParams: ['active']

  currentCode: null
  activeCode: null


  showActive: notEmpty('activeCode')

  showCurrent: ( ->
    isNone(@get('activeCode')) && @get('currentCode')
  ).property('activeCode', 'currentCode')


  actions:
    changedActiveCode: (code)->
      @set('activeCode', code)

    changedCurrentCode: (code)->
      @set('currentCode', code)

    setActive: (addr) ->
      @set('activeAddress', addr)
)

export default MainReceiveController
