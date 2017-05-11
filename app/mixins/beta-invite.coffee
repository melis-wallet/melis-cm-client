`import Ember from 'ember'`
`import config from '../config/environment';`
`import {isAjaxError, isNotFoundError, isForbiddenError} from 'ember-ajax/errors'`

INVITE_URIS= {
  regtest: 'https://www-regtest.melis.io/scripts/check.php'
  test: 'https://www-test.melis.io/scripts/check.php'
  main: 'https://www.melis.io/scripts/check.php'
}

TESTTOKEN = '12345678'

BetaInvite = Ember.Mixin.create(

  ajax: Ember.inject.service()

  _inviteUrl: ( ->
    INVITE_URIS[@get('cm.network')]
  ).property('cm.network')

  _doInviteRequest: (token, confirm) ->
    method =
      if confirm then 'DELETE' else 'GET'

    @get('ajax').request(@get('_inviteUrl'),
      method: method
      data:
        token: token
    ).catch((e) ->
      Ember.Logger.error "Invite check failed: ", e
      if isNotFoundError(e)
        throw {ex: 'TokenFailure', msg: @get('i18n').t('aa.error.token-failure')}
      if isAjaxError(e)
        throw {ex: 'TokenFailure', msg: @get('i18n').t('aa.error.token-failure')}
      else
        throw {ex: 'TokenError', msg: @get('i18n').t('aa.error.generic')}
    )

  validateInvite: (token) ->
    if @get('cm.testMode') && token == TESTTOKEN
      return Ember.RSVP.resolve(true)

    @_doInviteRequest(token, false).then((res) ->
      if Ember.get(res, 'status') == 'ok' then true else false
    ).catch((e) -> throw(e))

  confirmInvite: (token) ->
    if @get('cm.testMode') && token == TESTTOKEN
      return Ember.RSVP.resolve(true)
    @_doInviteRequest(token, true)

  #
  # Ask a token to complete the operation
  #
  checkInvite: (operation)->
    pending = Ember.RSVP.defer()

    if request = @get('pendingRequest')
      pending.reject(ex: 'TfaBusy', msg: @get('i18n').t('aa.error.busy'))
    else
      @setProperties(
        modalType: 'token'
        tfaOperation: operation
        aComponent: 'wallet/token-input'
        pendingRequest: pending
      )
      @get('modalManager').showModal(@get('modalId')).catch( =>
        @rejectPending(ex: 'TfaAborted', msg: @get('i18n').t('aa.error.token-req'))
      )

    return pending.promise


  validToken: (token, devicePass) ->
    operation = @get('tfaOperation')
    response = null

    self = @

    if operation
      if !Ember.get(operation, 'running')
        @validateInvite(token).then((res) ->
          Ember.set(operation, 'running', true)
          if res
            operation(token: token)
          else
            self.rejectPending(ex: 'TokenFailure', msg: @get('i18n').t('aa.error.token-invalid'))
        ).then((res) ->
          response = res
          self.confirmInvite(token)
        ).then((res) ->
          self.dismissAndResolve(response)
        ).catch((e) ->
          self.rejectPending(e)
        ).finally(->
          Ember.set(operation, 'running', false)
        )

    else
      @dismissAndResolve(null)




)

`export default BetaInvite`
