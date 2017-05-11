`import Ember from 'ember'`
`import layout from 'ember-leaf-tools/templates/components/leaf-editable-value'`

Parent = Ember.Component.extend(
  layout: layout


  classNames: ['editable-value']
  classNameBindings: ['hover']

  inputError: null

  editing: false

  value: null
  type: 'text'


  oldValue: null
  'text-area': false

  ident: null

  'if-empty': null
  'local-template': false
  'allow-enter': false

  additionalText: null

  autoresize: false
  maxlength: null

  size: 'sm'

  baseInputClass: "form-control animated fadeIn quick"
  inputClass: null

  #
  fullInputClass: ( ->
    { baseInputClass, sizeClass, inputClass } = @getProperties('baseInputClass', 'sizeClass', 'inputClass')

    "#{baseInputClass} #{sizeClass} #{inputClass}"
  ).property('sizeClass', 'baseInputClass', 'fullInputClass')

  displayedError: (->
    @get('errorMessage') || @get('inputError')
  ).property('inputError', 'errorMessage')

  displayEmpty: (->
    Ember.isBlank(@get('currentValue')) && !Ember.isBlank(@get('if-empty'))
  ).property('currentValue', 'if-empty')



  displayedValue: ( ->
    if (emptyVal = @get('if-empty')) && Ember.isBlank(@get('currentValue'))
      emptyVal
    else
      @get('currentValue')
  ).property('currentValue', 'if-empty')


  click: ->
    console.error "eeeeeee"
    #@setProperties
    #  oldValue: @get('currentValue')
    #  editing: true


  #
  sizeClass: ( ->
    "input-#{@get('size')}"
  ).property('size')

  resetValue: ->
    @initValue()

  #
  #
  #
  initValue: ->
    Ember.defineProperty(this, 'currentValue', Ember.computed.oneWay('value'))
    @set('isValid', true)

  #
  #
  #
  init: ->
    console.error "Hello init"
    @_super(arguments...)
    @initValue()
)


`export default Parent`