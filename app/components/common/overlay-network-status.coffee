`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`
`import { waitTime } from 'melis-cm-svcs/utils/delayed-runners'`

WAIT_CONNECT = 10000
WAIT_RESTART = 20000

OverlayNetworkStatus = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')
  classNameBindings: ['displayed::hidden']
  classNames: ['animated', 'fadeIn']

  force: false


  showConnect: false
  showRestart: false

  displayed: ( ->
    @get('force') || (@get('cm.connectSucceeded') && !@get('cm.connected'))
  ).property('cm.connected', 'cm.connectSucceeded', 'force')


  displayRecovery: task( ->
    yield waitTime(WAIT_CONNECT)
    @set('showConnect', true)
    yield waitTime(WAIT_RESTART)
    @set('showRestart', true)
  ).drop()

  resetStates: ( ->
    @setProperties
      showConnect: false
      showRestart: false

    if @get('displayed')
      console.error "hello"
      @get('displayRecovery').perform()
    else
      @get('displayRecovery').cancelAll()
  ).observes('displayed').on('init')

  actions:
    doRestart: ->
      window.location.reload()

    doConnect: ->
      @get('cm').reconnect()
)

`export default OverlayNetworkStatus`
