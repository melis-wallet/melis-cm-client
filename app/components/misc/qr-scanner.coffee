`import Ember from 'ember'`
`import Scheduler from 'ember-leaf-tools/utils/scheduler'`

QrScanner = Ember.Component.extend(


  # stop scanning when a valid code is found
  stopOnFound: true

  # show play controls
  showControls: true

  # show grid
  showGrid: true

  # autostart
  autostart: false

  # actively scanning for a barcode
  scanning: false

  # geometry of the video source
  width: null
  height: null

  # video element, and canvas
  video: null
  canvas: null
  ctx: null

  # getUserMedia
  gum: Ember.K
  hasMediaStreamTrackSources: false

  # timer
  scheduler: Scheduler.create(interval: 500)

  # a media error occurred
  mediaError: null

  # platform doesn't support userMedia
  userMediaFailed: false

  # last found code
  lastFound: null

  # last found code is valid
  valid: Ember.computed.bool('lastFound')


  setup: (->

    canvas = @.$('#qr-canvas')[0]
    video  = @.$('#camera-video')[0]

    ctx = canvas.getContext('2d')

    qrcode.callback = (data) =>
      try
        if(data)
          Ember.Logger.info('== Barcode Scanner: ', data)

          if @get('stopOnFound')
            @disableVideoCapture()

          @set('lastFound', data)
          @sendAction('on-valid-code', data)
      catch e
        Ember.Logger.error e



    if gum = @getUserMedia()

      @setProperties(
        video: video
        canvas: canvas
        ctx: ctx

        gum: gum
        hasEnumDevices: (typeof navigator.mediaDevices != "undefined" && navigator.mediaDevices != null) && navigator.mediaDevices.enumerateDevices
        hasMediaStreamTrackSources: (typeof MediaStreamTrack != "undefined" && MediaStreamTrack != null) && MediaStreamTrack.getSources
      )

      if @get('autostart')
        Ember.run.scheduleOnce('afterRender', this, ->
          @enableVideoCapture()
        )

  # changeme? different callback?
  ).on('didInsertElement')


  teardown: (->
    console.debug('+ tearing scanner down')
    if scheduler = @get('scheduler')
      scheduler.stop()
    @disableVideoCapture()
  ).on('willDestroyElement')

  #
  # (kind of) portable getUserMedia
  #
  getUserMedia: ->
    gum = navigator.getUserMedia || navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia || navigator.msGetUserMedia

    unless gum
      @set('userMediaFailed', true)
    gum


  #
  # prepares the destination canvas
  #
  prepareCanvas: ->
    v = @getProperties('video', 'canvas', 'ctx')
    $video = $(v.video)
    width = $video.width()
    height = $video.height()

    v.canvas.width = width
    v.canvas.height = height

    v.ctx.clearRect(0, 0, width, height)
    @setProperties(width: width, height: height)


  #
  # mediastream has changed
  #
  changedHasEnumDevices: (->
    mediaSource = null
    hasEnumDevices = @get('hasEnumDevices')


    self = @

    if(hasEnumDevices)
      navigator.mediaDevices.enumerateDevices().then((devices) =>
        #console.error "devs: ", devices
        # TODO, there seems not to be any way to select an environment facing source? wtf?
      )

  ).observes('hasEnumDevices')



  #
  # mediastream has changed
  #
  changedHasMediaStreamTrack: (->
    mediaSource = null
    hasSources = @get('hasMediaStreamTrackSources') && !@get('hasEnumDevices')

    self = @

    if (hasSources)
      MediaStreamTrack.getSources( (sources) ->
        sources.forEach( (source) ->
          if(source.kind == 'video' && source.facing == 'environment')
              mediaSource = source.id
        )

        self.set('mediaSource', mediaSource)
      )
  ).observes('hasMediaStreamTrackSources')


  #
  # start scheduling decoder
  #
  startScheduler: ->
    @set('lastFound', null)
    @cleanUpQR()
    @get('scheduler').schedule( =>
      @captureQR()
    )

  #
  # stop scheduling
  #
  stopScheduler: ->
    #
    # Not sure why it is necessary to delay the stop, just stopping caused the timer to
    # reschedule when a valid code was scanned
    #
    Ember.run.later(this, (->
      @get('scheduler').stop()
    ), 100)

  #
  #
  #
  scanningChanged: (->
    scanning = @get('scanning')
    if scanning
      @startScheduler()
    else
      @stopScheduler()
  ).observes('scanning')


  #
  #

  enableVideoCapture: ->
    # platform doesn't support user media
    return if @get('userMediaFailed')

    @set('mediaError', false)
    @prepareCanvas()

    props = @getProperties('width', 'height', 'video', 'canvas', 'ctx', 'gum', 'hasMediaStreamTrackSources')
    video = props.video

    gumCfg = {
      video: true
      audio: false
    }

    if props.hasMediaStreamTrackSources
      gumCfg.video = {
        optional: [{
          sourceId: @get('mediaSource')
        }]
      }

    self = @
    usermedia = (stream) =>
      @set('stream', stream)

      if ((typeof MediaStream != "undefined" && MediaStream != null) && stream instanceof MediaStream)
        video.srcObject = stream
        video.mozSrcObject = stream
        play = video.play()

        if play != undefined
          play.then( ->
            self.set('scanning', true)
          ).catch( (e) ->
            Ember.Logger.error('Scanner: play failed: ', e)
          )
        else
          @set('scanning', true)
      else
        vendorURL = window.URL || window.webkitURL
        video.src = if vendorURL
          vendorURL.createObjectURL(stream)
        else
          stream
        @set('scanning', true)


      video.onerror = (err) =>
        #@disableVideoCapture()
        Ember.Logger.error('Scanner: onerror')
        track = stream.getVideoTracks()[0]
        track.stop() if track
        @set('scanning', false)
        @sendAction('on-media-error', err)



    error = (err) =>
      Ember.Logger.error("Scanner: Get UM: ", err)
      @set('mediaError', true)
      @sendAction('on-media-error', err)

    props.gum.call(navigator, gumCfg, usermedia, error)

  disableVideoCapture: ->
    stream = @get('stream')
    video = @get('video')

    if stream
      video.pause()
      track = stream.getVideoTracks()[0]
      track.stop() if track
      @set('scanning', false)



  cleanUpQR: ->
    ctx = @get('ctx')
    canvas = @get('canvas')
    ctx.fillRect(0, 0, canvas.width, canvas.height)

  captureQR: ->
    video = @get('video')
    canvas = @get('canvas')
    ctx = @get('ctx')

    #ctx.fillRect(0, 0, canvas.width, canvas.height)
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height)

    try
      qrcode.decode()
    catch e


  actions:
    stopScan: ->
      @disableVideoCapture()

    startScan: ->
      @enableVideoCapture()



)

`export default QrScanner`
