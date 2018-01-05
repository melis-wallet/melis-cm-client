`import Ember from 'ember'`
`import StyleBody from 'ember-leaf-core/mixins/leaf-style-body'`
`import AuthenticatedRoute from '../mixins/authenticated-route'`


MainRoute = Ember.Route.extend(StyleBody, AuthenticatedRoute,

  classNames: ['animate-mm-lg', 'animate-mm-md', 'animate-mm-sm']


  init: ->
    @_super(arguments...)
    @get('cm').on('device-gone', this, (data) ->

      @get('cm').walletClose().then( => @transitionTo('wallet.no-creds'))
    )
)

`export default MainRoute`
