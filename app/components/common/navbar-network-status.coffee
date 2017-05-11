`import Ember from 'ember'`
`import TooltipSupport from 'ember-leaf-core/mixins/leaf-tooltip-support'`
`import { translationMacro as t } from "ember-i18n"`

I18N_PREFIX = 'netstatus.state'

NavbarNetworkStatus = Ember.Component.extend(TooltipSupport,
  tagName: 'li'
  classNames: ['nav-icon-btn']
  classNameBindings: ['connClass']

  cm: Ember.inject.service('cm-session')


  inserted: false

  st_ok:
    ident: 'ok'
    icon:  'fa fa-cloud-upload'
    klass: 'success'
    show:  false

  st_busy:
    ident: 'busy'
    icon:  'fa fa-cloud-upload'
    klass: 'warning'
    show: false

  st_dc:
    ident: 'dc'
    icon:  'fa fa-cloud-upload'
    klass: 'danger'
    show: true

  current:
    label: null
    title: null
    icon:  'fa fa-cloud-upload'
    klass: 'default'
    show: false
    text: null

  'tooltip-placement': 'bottom'

  'tooltip-class': (->
    'popover-dark popover-' + @get('current.klass')
  ).property('current')

  connClass: (->
    'nav-icon-btn-' + @get('current.klass')
  ).property('current')

  'popover-title': (->
    @get('i18n').t("#{I18N_PREFIX}.#{@get('current.ident')}.title")
  ).property('current')

  'popover': (->
    @get('i18n').t("#{I18N_PREFIX}.#{@get('current.ident')}.text")
  ).property('current')


  label: (->
    @get('i18n').t("#{I18N_PREFIX}.#{@get('current.ident')}.label")
  ).property('current')

  changeState: (->
    if @get('cm.connecting')
      @set 'current', @get('st_busy')
    else if @get('cm.connected')
      @set 'current', @get('st_ok')
    else
      @set 'current', @get('st_dc')
  ).observes('cm.connecting', 'cm.connected').on('init')


  do: (->
    # after render
    if @get('inserted')
      Ember.run.schedule('afterRender', this, @_displayPopover)
  ).observes('current')

  _displayPopover: ->
    if @get('current.show') && @get('popover')
      @.$().popover('show')
    else
      @.$().popover('hide')

  afterInsert: (->
    @set('inserted', true)
  ).on('didInsertElement')

)

`export default NavbarNetworkStatus`