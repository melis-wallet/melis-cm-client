`import Ember from 'ember'`

WalletSignOutRoute = Ember.Route.extend(

  beforeModel: (transition) ->
    cm = @get('cm')
    cm.walletClose().then(->
      console.log "Signed Out. Restarting..."
      window.location.replace('/')
    )


)

`export default WalletSignOutRoute`
