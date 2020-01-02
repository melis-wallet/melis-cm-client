import Route from '@ember/routing/route'

MainAccountAddressIxdRoute = Route.extend(

  model: ->
    @modelFor('main.account.address')

)

export default MainAccountAddressIxdRoute