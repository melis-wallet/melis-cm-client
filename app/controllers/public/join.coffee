`import Ember from 'ember'`

JoinController = Ember.Controller.extend(

  credentials: Ember.inject.service('cm-credentials')

  error: null
  success: null

  enrolling: false

  joinCode: Ember.computed.alias('model.code')

  actions:
    confirmJoin: ->
      @setProperties
        error: null
        success: null

      i18n = @get('i18n')

      if code =  @get('joinCode')
        @get('cm').accountJoin(code: code, meta: {name: i18n.t('account.multi.join.default-name').toString()}).then( (res) =>
          @set 'success', i18n.t('public.join.success')
        ).catch( (err) =>
          if err.ex == 'CmCodeNotFoundException'
            @set('error', i18n.t('public.join.not-found'))
          else
            @set('error', i18n.t('public.join.error'))
        )

    startEnroll: ->
      @set 'enrolling', true

    doneSetPINJoin: (pin) ->
      cm = @get('cm')
      i18n = @get('i18n')

      if code =  @get('joinCode')
        cm.enrollWallet(pin).then( (wallet) =>
          @get('cm').accountJoin(code: code, meta: {name: i18n.t('account.multi.join.default-name').toString()})
        ).then((res) =>
          @set 'success',  i18n.t('public.join.success')
        ).catch( (err) ->
          Ember.Logger.error "enroll failed: ", err
          @set 'error', err.msg
        )

)

`export default JoinController`
