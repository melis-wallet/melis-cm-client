
CmSessionInitializer = {
  name: 'cm-session'

  initialize: (application) ->
    application.inject('controller', 'cm', 'service:cm-session')
    application.inject('route', 'cm', 'service:cm-session')

}

`export default CmSessionInitializer`