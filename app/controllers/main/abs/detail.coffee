`import Ember from 'ember'`
`import { task, taskGroup } from 'ember-concurrency'`

AbsController = Ember.Controller.extend(

  accountInfo: null

  lazyfetchInfo: task( ->
    @set('accountInfo', null)

    if (entry = @get('model')) && Ember.get(entry, 'isCm') && (val = Ember.get(entry, 'val'))
      api = @get('cm.api')
      try
        res = yield api.accountGetPublicInfo(name: val)
        @set('accountInfo', res)
      catch error
        Ember.Logger.error error
  )

  modelChanged: ( ->
    @get('lazyfetchInfo').perform()
  ).observes('model')

)

`export default AbsController`
