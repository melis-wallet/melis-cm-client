import Helper from '@ember/component/helper'
import { inject as service } from '@ember/service'

TIME_PER_BLOCK = 600

EstimateBlockTime = Helper.extend(

  cm: service('cm-session')

  compute: (params, hash) ->
    block = params[0]
    time = @get('cm').estimateBlockTime(block)

    if hash.relative
      moment(time).fromNow()
    else
      moment(time).calendar()

)

export default EstimateBlockTime