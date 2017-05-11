`import Ember from 'ember'`

CoSigner = Ember.Helper.extend(

  cm:  Ember.inject.service('cm-session')

  compute: (params, hash) ->
    id = params[0]

    cA = hash.account || @get('cm.currentAccount')

    return id unless cA
    cA.cosignerName(id, {you: hash.you, idIsFine: true})
)

`export default CoSigner`