`import Ember from 'ember'`

STORAGE_PREFIX = 'storage:recovery-info:cm-account:'

NoserverRecovery = Ember.Component.extend(

  entries: []
  filenameBase: '-recovery.json'

  getEntries: ->
    entries = []
    for i in [0..localStorage.length]
      key = localStorage.key(i)
      if key && key.startsWith(STORAGE_PREFIX)
        val = Ember.get(JSON.parse(localStorage[key]), 'current')
        entries.pushObject(val)
    entries

  setup: (->
    @set('entries', @getEntries())
  ).on('init')
)

`export default NoserverRecovery`
