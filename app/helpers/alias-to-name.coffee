`import Ember from 'ember'`

AliasToName = Ember.Helper.extend(

  cm:  Ember.inject.service('cm-session')


  compute: (params, hash) ->
    alias = params[0]

    cA =
      if hash.account
        hash.account
      else
        @get('cm.currentAccount')

    return alias unless cA

    if cosigners = cA.get('info.cosigners')
      if z = cosigners.findBy('alias', alias)
        z.name
      else
        alias
    else
      alias

)

`export default AliasToName`