import Component from '@ember/component'

import Logger from 'melis-cm-svcs/utils/logger'


QrUploader = Component.extend(

  decoded: null
  imageUrl: null


  actions:
    resetUpload: ->
      @setProperties
        decoded: null
        imageUrl: null

    confirmUpload: ->
      if decoded = @get('decoded')
        @sendAction('on-confirm', decoded)

    onDrop: (dropzone) ->

    addQrcode: (file) ->
      self = @
      file.readAsDataURL().then((url) ->
        qrcode.callback= (data) =>
          Logger.info "[QR] decoded data:", data
          self.setProperties
           decoded: data
           imageUrl: url

        qrcode.decode(url)
      )
)

export default QrUploader
