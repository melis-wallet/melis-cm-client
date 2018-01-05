`import Ember from 'ember'`


groupBy = (collection, property) ->
  dependentKey = collection + '.@each.' + property

  return Ember.computed(dependentKey, ->
    groups = Ember.A()
    items = Ember.get(this, collection)
    return if Ember.isEmpty(items)

    items.forEach((item) ->
      value = Ember.get(item, property)
      group = groups.findBy('value', value)

      if Ember.isPresent(group)
        Ember.get(group, 'items').push(item)
      else
        group = { property: property, value: value, items: [item] }
        groups.push(group)

    )
    return groups
  ).readOnly()


`export default groupBy`