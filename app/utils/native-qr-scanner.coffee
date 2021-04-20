import EmberObject from '@ember/object'
import RSVP from 'rsvp'

NativeQrScanner = EmberObject.extend(

  prepare: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.prepare((err, status) ->
        if (err)
          reject(err: err, status: status)

        if status.authorized
          resolve(status: status)
        else
          reject(status: status)
      )
    )

  scan: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.scan((err, data) ->
        if (err)
          reject(err: err)
        resolve(data)
      )
    )


  cancelScan: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.cancelScan((status) -> resolve(status))
    )

  destroy: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.destroy((status) -> resolve(status))
    )

  pausePreview: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.pausePreview((status) -> resolve(status))
    )

  resumePreview: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.resumePreview((status) -> resolve(status))
    )

  show: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.show((status) -> resolve(status))
    )


  hide: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.hide((status) -> resolve(status))
    )

  getStatus: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.getStatus((status) -> resolve(status))
    )

  useFrontCamera: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.useFrontCamera((err, status) ->
        reject(err) if err
        resolve(status)
      )
    )


  useFrontCamera: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.useFrontCamera((err, status) ->
        reject(err) if err
        resolve(status)
      )
    )

  useBackCamera: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.useBackCamera((err, status) ->
        reject(err) if err
        resolve(status)
      )
    )

  useCamera: (front) ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.useCamera(front, (err, status) ->
        reject(err) if err
        resolve(status)
      )
    )


  enableLight: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.enableLight((err, status) ->
        reject(err) if err
        resolve(status)
      )
    )

  disableLight: ->
    return new RSVP.Promise((resolve, reject) ->
      QRScanner.disableLight((err, status) ->
        reject(err) if err
        resolve(status)
      )
    )

)

export default NativeQrScanner
