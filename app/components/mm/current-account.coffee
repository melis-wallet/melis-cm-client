import Component from '@ember/component'
import { inject as service } from '@ember/service'
import { A } from '@ember/array'

import ActiveLinkMixin from 'ember-cli-active-link-wrapper/mixins/active-link'

CurrentAccount = Component.extend(
  #ActiveLinkMixin,

  tagName: 'li'
  ariaRole: 'menu-item'
  classNames: ['menu-item', 'current-acct', 'animated', 'fadeIn']
  classNameBindings: ['active', 'linkActive:active']
  account: null

  app_state: service('app-state')

  linkActive: (->
     A(@get('childLinkViews')).isAny('active')
  ).property('childLinkViews.@each.active')

  linkFollowed: ((event)->
    event.preventDefault()
    @get('app_state').routingStateChanged()
  ).on('click')
)

export default CurrentAccount
