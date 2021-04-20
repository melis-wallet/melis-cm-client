import Component from '@ember/component'
import { oneWay, notEmpty } from '@ember/object/computed'
import { alias } from '@ember/object/computed'
import { bool } from '@ember/object/computed'
import { inject as service } from '@ember/service'
import { observer, computed } from "@ember/object"
import { task } from 'ember-concurrency'
import NativeQrScanner from '../../utils/native-qr-scanner'
import jQuery from 'jquery'
import { scheduleOnce, later } from '@ember/runloop'
import RSVP from 'rsvp'

ScannerContainer = Component.extend(
  svc: service('scanner-provider')
  tagName: ''

  active: alias('svc.nativeScannerActive')
  #active: true

# stop scanning when a valid code is found
  stopOnFound: true

# show camera controls
  showControls: true

# show media controls
  showMediaControls: false

# show grid
  showGrid: true

# autostart
  autostart: true

# actively scanning for a barcode
  scanning: false

# a media error occurred
  mediaError: null

# flash on
  flash: false

  frontCamera: false

# last found code
  lastFound: null

# last found code is valid
  valid: bool('lastFound')

  scanner: null

  displayGrid: computed('showGrid', 'scanning', ->
    @get('showGrid') && @get('scanning') && !@get('mediaError')
  )

  observeState: observer('active', ->
    if @get('active')
      @onActivation.perform()
    else
      @onDeactivation.perform()
  )


  onActivation: task( ->
    console.debug '[scanner] onactivation'

    yield @showScanner.perform()
    jQuery('body').addClass('native-scanner')

    if @autostart
      yield @startScanner.perform()
  )

  onDeactivation: task(->
    console.debug '[scanner] onDeactivation'

    yield @disableScanner.perform()
    jQuery('body').removeClass('native-scanner')
  )

  showScanner: task( ->
    console.debug '[scanner] show'
    try
      yield @scanner.show()
    catch e
      console.error "[scanner] error: ", e
  )

  hideScanner: task( ->
    console.debug '[scanner] hide'
    try
      yield @scanner.hide()
      @_scheduleBgFix()
    catch e
      console.error "[scanner] error: ", e
  )


  _scheduleBgFix: ->
    scheduleOnce('afterRender', ->
      later(this, ->
        jQuery('body').css("background-color", '') #.css('background', '')
      , 250))

  startScanner: task(->
    console.debug '[scanner] start'
    try
      @set('scanning', true)

      #scheduleOnce('afterRender', ->
      #  later(this, ->
      #    jQuery('body').css('background', 'transparent !important').css("background-color", 'transparent')
      #  ,250)
      #)

      yield @scanner.show()
      data = yield @scanner.scan()

      @set('scanning', false)
      @validData(data)
    catch e
      if e.err?.name != 'SCAN_CANCELED'
        console.error "[scanner] start error: ", e
        @set('mediaError', e)
      else
        console.debug '[scanner] scan terminated'
      @set('scanning', false)
  )

  stopHideScanner: task( ->
    console.debug '[scanner] stophide'
    @set('scanning', false)

    try
      @scanner.cancelScan()
      yield @scanner.hide()
      @_scheduleBgFix()
    catch e
      console.error "[scanner] stophide error: ", e
  )


  stopScanner: ->
    console.debug '[scanner] stop'

    try
      @scanner.cancelScan()
      console.debug '[scanner] stopping'
      @set('scanning', false)
    catch e
      console.error "[scanner] stop error: ", e


  switchCamera: task((front) ->
    console.debug '[scanner] switchamera: ', front

    if front
      front = 1
    else
      front = 0


    try
      yield @scanner.useCamera(front)
    catch e
      console.error "[scanner] error: ", e
  )

  toggleFlash: task((state) ->
    console.debug '[scanner] flash: ', state
    try
      if state
        yield @scanner.enableLight()
      else
        yield @scanner.disableLight()
    catch e
      console.error "[scanner] error: ", e
  )


  disableScanner: task(->
    console.debug '[scanner] disablescanner', @scanning
    try
      yield @stopScanner() if @get('scanning')
      yield @hideScanner.perform()
    catch e
      console.error "[scanner] error: ", e

    try
      yield @scanner.destroy() if @scanner
    catch e
      console.error "[scanner] error: ", e
  )



  validData: (data) ->
    console.debug '[scanner] validata: ', data
    @set('lastFound', data)
    @get('on-data')(data, this) if @get('on-data')

    if @stopOnFound
      @disableScanner.perform().then( =>
        @get('on-valid-code')(data, this) if @get('on-valid-code')
        @get('on-dismiss')(data) if @get('on-dismiss')
        @svc.successAcquire(data)
      )


  didInsertElement: ->
    @_super(arguments...)
    @set('scanner', NativeQrScanner.create())
    @get('active')



  willDestroyElement: ->
    @disableScanner.perform().then( =>
      console.debug '[scanner] successfully disabled'
      @svc.abortAcquire() if @get('active')
    )
    @_scheduleBgFix()


  actions:
    abortAcquire: ->
      console.debug '[scanner] abortacquire'
      @disableScanner.perform().then( =>
        console.debug '[scanner] successfully disabled'
        @svc.abortAcquire() if @get('active')
      )

    stopScan: ->
      @stopScanner()

    startScan: ->
      @startScanner.perform()

    nextSource: ->
      camera = @toggleProperty('frontCamera')
      @switchCamera.perform(camera)

    flipSource: ->
#camera = @toggleProperty('frontCamera')
#@switchCamera.perform(camera)

    toggleFlash: ->
      flash = @toggleProperty('flash')
      @toggleFlash.perform(flash)
)

export default ScannerContainer
