`import Ember from 'ember'`
`import SizeSupport from 'ember-leaf-core/mixins/leaf-size-support'`

TYPES = ['address', 'account', 'cm']
TYPES_SIMPLE = ['address', 'cm']

ICONS = {
  address: 'fa fa-btc'
  cm: 'fa fa-vcard'
  account: 'fa fa-share-square'
}

DestinationType = Ember.Component.extend(SizeSupport,
  tagName: 'button'
  classNames: ['btn', 'btn-outline', 'btn-primary']
  classTypePrefix: 'btn'

  'dst-type': 'address'

  cm: Ember.inject.service('cm-session')

  currentType: Ember.computed.oneWay('dst-type')

  iconClass: ( -> ICONS[@get('dst-type')] ).property('currentType')

  availableTypes: ( ->
    if @get('cm.accounts.length') > 1
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

`export default DestinationType`


