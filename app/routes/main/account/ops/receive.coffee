import Route from '@ember/routing/route'
import { inject as service } from '@ember/service'

MainAccounReceiveRoute = Route.extend(

  service: service('cm-address-provider')

  beforeModel: (transition) ->
    if !@get('cm.currentAccount.isComplete')
      @transitionTo('main.account.summary', @get('cm.currentAccount.pubId'))

)

export default MainAccounReceiveRoute