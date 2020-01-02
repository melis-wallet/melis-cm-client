import { helper } from '@ember/component/helper'

ROUTES = {
  txinfo: 'main.account.history.detail'
}

RouteToObj = helper((params) ->
  obj = params[0]
  return ROUTES[obj] || raise "object '#{obj}' not found in route-to-obj helper"
)

export default RouteToObj