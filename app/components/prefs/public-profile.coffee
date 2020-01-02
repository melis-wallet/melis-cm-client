import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { alias } from '@ember/object/computed'

import { task, timeout } from 'ember-concurrency'
import { filterProperties, mergedProperty } from 'melis-cm-svcs/utils/misc'

import Logger from 'melis-cm-svcs/utils/logger'

PublicProfile = Component.extend(

  cm: service('cm-session')

  account: alias('cm.currentAccount')

  busy: false

  updateMeta: task((updates) ->
    if account = @get('cm.currentAccount.cmo')
      pubMeta = mergedProperty(account, 'pubMeta', filterProperties(updates, 'name', 'address', 'profile'))
      console.log "Saving: ", pubMeta
      try
        yield @get('cm.api').accountUpdate(account, pubMeta: pubMeta)
      catch err
        Logger.error 'Error updating meta: ', err
  ).enqueue()

  actions:
    changedName: (name) ->
      @get('updateMeta').perform(name: name)

    changedAddress: (address) ->
      @get('updateMeta').perform(address: address)

    changedProfile: (profile) ->
      @get('updateMeta').perform(profile: profile)

)

export default PublicProfile
