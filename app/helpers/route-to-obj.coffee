`import Ember from 'ember'`

ROUTES = {
  txinfo: 'main.account.history.detail'
}

RouteToObj =  Ember.Helper.helper((params) ->
  obj = params[0]
  return ROUTES[obj] || raise "object '#{obj}' not found in route-to-obj helper"
)

`export default RouteToObj`