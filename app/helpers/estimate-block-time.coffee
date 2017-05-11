`import Ember from 'ember'`

TIME_PER_BLOCK = 600

EstimateBlockTime = Ember.Helper.extend(

  cm:  Ember.inject.service('cm-session')

  compute: (params, hash) ->
    block = params[0]
    time = @get('cm').estimateBlockTime(block)

    if hash.relative
      moment(time).fromNow()
    else
      moment(time).calendar()

)

`export default EstimateBlockTime`