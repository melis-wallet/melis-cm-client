`import Ember from 'ember'`
`import { task, timeout } from 'ember-concurrency'`
`import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'`

PublicProfile = Ember.Component.extend(

  cm: Ember.inject.service('cm-session')

  account: Ember.computed.alias('cm.currentAccount')

  busy: false

  updateMeta: task((updates) ->
    if account = @get('cm.currentAccount.cmo')
      pubMeta = mergedProperty(account, 'pubMeta', filterProperties(updates, 'name', 'address', 'profile'))
      console.log "Saving: ", pubMeta
      try
        yield @get('cm.api').accountUpdate(account, pubMeta: pubMeta)
      catch err
        Ember.Logger.error 'Error updating meta: ', err
  ).enqueue()

  actions:
    changedName: (name) ->
      @get('updateMeta').perform(name: name)

    changedAddress: (address) ->
      @get('updateMeta').perform(address: address)

    changedProfile: (profile) ->
      @get('updateMeta').perform(profile: profile)

)

`export default PublicProfile`
