`import Ember from 'ember'`

JoinRoute = Ember.Route.extend(


  cm: Ember.inject.service('cm-session')


  model: (params) ->

    @get('cm').waitForConnect().then( =>
      @get('cm.api').accountGetPublicInfo(code: params.code).then((info) ->
        info.code = params.code
        return info
      )
    )
)

`export default JoinRoute`
