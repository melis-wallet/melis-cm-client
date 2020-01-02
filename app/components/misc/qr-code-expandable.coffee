import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { scheduleOnce } from '@ember/runloop'


QrCodeExpandable = Component.extend(

  mm: service('modals-manager')
  resp: service('responsive-media')

  classNames: ['expandable']

  content: null
  placeholder: null

  expanded: false

  'img-class': null


  codeId: ( ->
    'qc-' + @get('elementId')
  ).property('elementId')

  #
  #
  #
  height: 128
  width: 128

  colorDark: '#000000'
  colorLight: '#ffffff'


  qrSize: ( ->
    if @get('resp.isMobile')
      256
    else
      480
  ).property('resp.isMobile')


  actions:
    toggleExpand:  ->
      if !@get('expanded')
        @set('expanded', true)

        scheduleOnce('afterRender', this, ->
          @get('mm').showModal(@get('codeId')).then((res) ->

          ).catch((err) ->
            # dismissed
          ).finally( =>
            @set('expanded', false)
          )
        )
)

export default QrCodeExpandable