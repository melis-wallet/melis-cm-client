`import Ember from 'ember'`
`import ActiveLinkMixin from 'ember-cli-active-link-wrapper/mixins/active-link'`

CurrentAccount = Ember.Component.extend(
  #ActiveLinkMixin,

  tagName: 'li'
  ariaRole: 'menu-item'
  classNames: ['menu-item', 'current-acct', 'animated', 'fadeIn']
  classNameBindings: ['active', 'linkActive:active']
  account: null

  app_state: Ember.inject.service('app-state')

  linkActive: (->
     Ember.A(@get('childLinkViews')).isAny('active')
  ).property('childLinkViews.@each.active')

  linkFollowed: ((event)->
    event.preventDefault()
    @get('app_state').routingStateChanged()
  ).on('click')


)

`export default CurrentAccount`
