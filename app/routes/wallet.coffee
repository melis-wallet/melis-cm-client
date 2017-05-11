`import Ember from 'ember'`
`import StyleBody from 'ember-leaf-core/mixins/leaf-style-body'`

WalletRoute = Ember.Route.extend(StyleBody,
 classNames: ['page-signin']
)

`export default WalletRoute`
