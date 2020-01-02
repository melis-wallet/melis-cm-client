import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { bool } from '@ember/object/computed'
import { isEmpty, isBlank } from '@ember/utils'
import { scheduleOnce, later } from '@ember/runloop'
import Scheduler from 'ember-leaf-tools/utils/scheduler'

import Instascan from 'npm:instascan'
import { task } from 'ember-concurrency'

import Logger from 'melis-cm-svcs/utils/logger'


QrScanner = Component.extend(


  # stop scanning when a valid code is found
  stopOnFound: true

  # show camera controls
  showControls: true

  # show media controls
  showMediaControls: false

  # show grid
  showGrid: true

  # autostart
  autostart: false

  # actively scanning for a barcode
  scanning: false

  # timer
  scheduler: Scheduler.create(interval: 500)

  # a media error occurred
  mediaError: null

  # platform doesn't support userMedia
  userMediaFailed: false

  # last found code
  lastFound: null

  # last found code is valid
  valid: bool('lastFound')

  scanner: null

  cameras: null
  currentCamera: null
  flip: false


  didInsertElement: ->
    @_super(arguments...)
    @initScanner.perform()


  willDestroyElement: ->
    @_super(arguments...)
    @cleanupScanner.perform()


  multipleSources: ( ->
    @cameras?.length > 1
  ).property('cameras.[]')


  defaultCamera: ( ->

    @cameras.firstObject
  ).property('cameras.[]')


  initScanner: task(->

    scanner = new Instascan.Scanner(
      continuos: true
      mirror: false
      video: document.getElementById('camera-video')
    )

    scanner.addListener('scan', (content) =>
      console.log "[scanner] data: ", content
      @validData(content)
    )

    @set('scanner', scanner)


    yield @detectCameras.perform()

    if @get('autostart') && !isEmpty(@cameras)
      yield @enableVideoCapture.perform()
  ).drop()


  changeSource: task((source) ->

    yield @stopScanner.perform()
    unless @scanning
      yield @startScanner.perform(source)
  )


  enableVideoCapture: task( ->
    if !isEmpty(@cameras)
      @setProperties
        currentCamera: @defaultCamera
      yield @startScanner.perform(@currentCamera)
  ).drop()



  cleanupScanner: task( ->
    yield @stopScanner.perform()

  ).drop()



  detectCameras: task( ->
    try
      cameras = yield Instascan.Camera.getCameras()
      console.debug cameras
      @set('cameras', cameras)
    catch error
      console.error "[scanner] detect error: ", error
      @set('userMediaFailed', true)
  )


  startScanner: task((camera) ->

    return if isEmpty(@cameras)

    camera ||= @currentCamera || @defaultCamera
    return unless camera

    console.log('[scanner] start on: ', camera)
    @setProperties
      currentCamera: camera
      mediaError: false

    try
      yield @scanner.start(camera)
      console.log('camera started')
      @set('scanning', true)
    catch error
      console.error "[scanner] start error: ", error
      @set('mediaError', true)
  ).drop()

  stopScanner: task( ->

    try
      yield @scanner.stop()
      console.debug('[scanner] camera stopped')
      @set('scanning', false) unless @isDestroyed
    catch error
      console.error "[scanner] stop error: ", error

  ).drop()


  getNextSource: ( ->
    return @defaultCamera if (!@multipleSources || isBlank(@currentCamera))
    console.error "HERE", @multipleSources, @currentCamera

    cameraIndex = @cameras.indexOf(@currentCamera)
    console.error "index", cameraIndex

    cameraIndex += 1
    if cameraIndex > (@cameras.length - 1)
      cameraIndex = 0

    console.error 'new', cameraIndex, @cameras[cameraIndex]
    @cameras[cameraIndex]

  )


  validData: (data) ->
    @set('lastFound', data)
    @get('on-data')(data, this) if @get('on-data')

    if @stopOnFound
      @stopScanner.perform().then(=>
        @get('on-valid-code')(data, this) if @get('on-valid-code')
        @get('on-dismiss')(data) if @get('on-dismiss')
      )




  actions:
    stopScan: ->
      @stopScanner.perform()

    startScan: ->
      @startScanner.perform()

    nextSource: ->
      if (src = @getNextSource())
        @changeSource.perform(src)

    flipSource: ->



)

export default QrScanner
