import Route from '@ember/routing/route'

import StyleBody from 'ember-leaf-core/mixins/leaf-style-body'

WalletRoute = Route.extend(StyleBody,
 classNames: ['page-signin']
)

export default WalletRoute
