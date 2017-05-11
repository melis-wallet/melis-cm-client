`import Ember from 'ember'`
`import ResizeAware from 'ember-resize/mixins/resize-aware'`

SparkLine = Ember.Component.extend( ResizeAware,

  #tagName: 'span'
  values: Ember.A()

  options: {
		type: 'line'
		width: '100%'
		height: '45px'
		fillColor: ''
		lineColor: '#fff'
		lineWidth: 2
		spotColor: '#ffffff'
		minSpotColor: '#ffffff'
		maxSpotColor: '#ffffff'
		highlightSpotColor: '#ffffff'
		highlightLineColor: '#ffffff'
		spotRadius: 4
  }

  sparkline: null

  setup: (->
    @_redrawLine()
  ).on('didInsertElement')

  _redrawLine: ->
    if values = @get('values')
      @set('sparkline', @.$().sparkline(values, @get('options')))

  debouncedDidResize: ->
    Ember.run.scheduleOnce 'afterRender', this, @_redrawLine

	shouldRedraw: (->
		Ember.run.scheduleOnce 'afterRender', this, @_redrawLine
  ).observes('values')

)


`export default SparkLine`