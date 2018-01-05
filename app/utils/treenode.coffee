`import Ember from 'ember'`

TreeNode = Ember.Object.extend(

  children: null
  parent: null

  selected: false
  expanded: false

  hasChildren: (->
    !!@get('children.length')
  ).property('children.length')

  hasParent: (->
    !!@get('parent')
  ).property('parent')

  root: ( ->
    node = this
    while (node.get('hasParent'))
      if !node.get('hasParent')
        return node
      else
        node = node.get('parent')
    return node
  ).property('parent')


  leaf: ( ->
    !@get('children.length')
  ).property('children.length')

  level: (->
    i = 0
    node = this
    while (node.get('hasParent'))
      i++;
      node = node.get('parent')
    return i

  ).property('parent')

  isRoot: ( ->
    !@get('hasParent')
  ).property('parent')

  init: ( ->
    @_super(arguments...)
    if (ch = @get('children.firstObject')) && (Ember.typeOf(ch != 'TreeNode'))
      children = @get('children')
      @emptyChildren()
      children.forEach((c) => @createChild(c))

  )

  #parseChildren: (ary) ->
  #  if (ch = ary.get('firstObject')) && (Ember.typeOf(ch != 'TreeNode'))

  addChild: (node) ->
    if (!ch = @get('children'))
      @emptyChildren()
    node.set('parent',this)
    ch.pushObject(node)
    node

  createChild: (obj) ->
    c = TreeNode.create(obj)
    @addChild(c)

  removeChild: (node) ->
    node.set('parent', null)
    @get('children').removeObject(node)

  emptyChildren: ->
    @set('children', Ember.A())


  allDescendants: ->
    res = Ember.A()
    @get(children).forEach((c) ->
      res.pushObject(c)
      res.pushObjects(c.allDescendants())
    )
    res

  findChildrenBy: (key, value) ->
    @allDescendants().findBy(key, value)

)




`export default TreeNode`