import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { oneWay } from "@ember/object/computed"
import SizeSupport from 'ember-leaf-core/mixins/leaf-size-support'

TYPES = ['address', 'account', 'cm']
TYPES_SIMPLE = ['address', 'cm']

ICONS = {
  address: 'fa fa-barcode'
  cm: 'fa fa-vcard'
  account: 'fa fa-share-square'
}

DestinationType = Component.extend(SizeSupport,
  tagName: 'button'
  classNames: ['btn', 'btn-outline', 'btn-primary']
  classTypePrefix: 'btn'

  showall: false

  'dst-type': 'address'

  cm: service('cm-session')

  currentType: oneWay('dst-type')

  iconClass: ( -> ICONS[@get('dst-type')] ).property('currentType')

  availableTypes: ( ->
    if @get('showall') ||  (@get('cm.accounts.length') > 1)
      TYPES
    else
      TYPES_SIMPLE
  ).property('cm.accounts.length')

  nextType: ->
    { currentType,
      availableTypes } = @getProperties('currentType', 'availableTypes')

    i = availableTypes.indexOf(currentType)
    availableTypes[ if ( i == availableTypes.length - 1) then 0 else ( i + 1 )]


  click: (e) ->
    e = @nextType()
    @sendAction('on-type-change', @nextType())


)

export default DestinationType


