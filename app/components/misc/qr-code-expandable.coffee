`import Ember from 'ember'`


QrCodeExpandable = Ember.Component.extend(

  mm: Ember.inject.service('modals-manager')
  resp: Ember.inject.service('responsive-media')

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
      console.log "click"
      if !@get('expanded')
        @set('expanded', true)

        Ember.run.scheduleOnce('afterRender', this, ->
          @get('mm').showModal(@get('codeId')).then((res) ->

          ).catch((err) ->
            # dismissed
          ).finally( =>
            @set('expanded', false)
          )

        )

)

`export default QrCodeExpandable`