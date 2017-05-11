`import Ember from 'ember'`


QrCode = Ember.Component.extend(

  content: null
  placeholder: null

  'img-class': null

  classNameBindings: ['isPlaceholder:placeholder']

  #
  #
  #
  height: 128
  width: 128

  colorDark: '#000000'
  colorLight: '#ffffff'

  correctLevel: QRCode.CorrectLevel.H

  text: ( ->
    @get('content') || @get('placeholder')
  ).property('content', 'placeholder')

  contentChanged: (->
    Ember.run.scheduleOnce 'afterRender', this, @_makeCode
  ).observes('content')

  setup: (->
    @_createCode()
  ).on('didInsertElement')

  isPlaceholder: ( ->
    Ember.isBlank(@get('content')) && @get('placeholder')
  ).property('content', 'placeholder')


  tearOff: (->
    qr.clear() if qr = @get('image')
  ).on('willDestroyElement')


  click: (evt) ->
    @sendAction('on-click')

  _createCode: ->
    options = @getProperties('text', 'width', 'height', 'colorDark', 'colorLight', 'correctLevel')
    qr =  new QRCode(@.$()[0], options)
    @set('image', qr)
    @.$('img').addClass(@get('img-class'))

  _makeCode: ->
    if (qr = @get('image')) && (content = @get('content'))
      qr.makeCode(content)

)

`export default QrCode`