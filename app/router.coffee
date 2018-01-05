`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend(
  location: config.locationType,
  rootURL: config.rootURL
)

Router.map ->
  @route 'main', ->
    @route 'wallet'
    @route 'accounts'
    @route 'account', {path: '/account/:account_id'},  ->
      @route 'view'
      @route 'dashboard'
      @route 'summary'
      @route 'ops', ->
        @route 'send'
        @route 'advanced-send'
        @route 'receive'
      @route 'history', ->
        @route 'detail', {path: ':txinfo_id'}
      @route 'ptx', ->
        @route 'detail', {path: ':ptx_id'}
      @route 'unspents'
      @route 'address', ->
        @route 'detail', {path: ':addr_id'}
    @route 'abs',  ->
      @route 'new'
      @route 'detail', {path: ':entry_id'}
      @route 'edit', {path: ':entry_id/edit'}
  @route 'wallet', ->
    @route 'sign-in'
    @route 'sign-out'
    @route 'options'
    @route 'enroll'
    @route 'backup'
    @route 'create-account'
    @route 'no-creds'
    @route 'pair-import'
    @route 'import'
    @route 'pair'
    @route 'recover'
    @route 'welcome'
  @route 'public', ->
    @route 'profile', {path: 'profile/:identifier'}
    @route 'payto', {path: 'payto/:identifier'}
    @route 'join', {path: 'join/:code'}
  @route 'info', ->
    @route 'export'
    @route 'noserver'

`export default Router`
