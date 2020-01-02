import { computed } from '@ember/object'
import { get, set } from '@ember/object'
import { A } from '@ember/array'
import { isEmpty, isPresent } from '@ember/utils'

groupBy = (collection, property) ->
  dependentKey = collection + '.@each.' + property

  return computed(dependentKey, ->
    groups = A()
    items = get(this, collection)
    return if isEmpty(items)

    items.forEach((item) ->
      value = get(item, property)
      group = groups.findBy('value', value)

      if isPresent(group)
        get(group, 'items').push(item)
      else
        group = { property: property, value: value, items: [item] }
        groups.push(group)
    )
    return groups
  ).readOnly()


export default groupBy