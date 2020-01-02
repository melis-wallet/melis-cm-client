import Component  from '@ember/component'
import { get } from '@ember/object'

STORAGE_PREFIX = 'storage:recovery-info:cm-account:'

NoserverRecovery = Component.extend(

  entries: []
  filenameBase: '-recovery.json'

  getEntries: ->
    entries = []
    for i in [0..localStorage.length]
      key = localStorage.key(i)
      if key && key.startsWith(STORAGE_PREFIX)
        val = get(JSON.parse(localStorage[key]), 'current')
        entries.pushObject(val)
    entries

  setup: (->
    @set('entries', @getEntries())
  ).on('init')
)

export default NoserverRecovery
