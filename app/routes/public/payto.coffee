`import Ember from 'ember'`

PayToRoute = Ember.Route.extend(


  cm: Ember.inject.service('cm-session')


  model: (params) ->

    @get('cm').waitForConnect().then( =>
      identifier = decodeURIComponent(params.identifier)
      @get('cm.api').accountGetPublicInfo(name: identifier)
    )
)

`export default PayToRoute`
