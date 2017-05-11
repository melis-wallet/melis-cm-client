`import { module, test, skip, moduleFor } from 'qunit'`
`import Ember from 'ember'`
`import config from '../../../config/environment'`

`import startApp from '../../helpers/start-app'`
`import { lookupService } from '../../helpers/utils/lookup'`


application = null

TESTPASS = 'Pa$$w0rd'

module('Integration: enroll',

  setup: (assert)->
    application = startApp()
    session = lookupService(application, 'cm-session')
    session.waitForConnect()


  teardown: ->
    Ember.run(application, 'destroy')


)


test 'ready for tests', (assert) ->

  visit '/wallet/enroll'

  andThen( ->
    Ember.run.later (->
      assert.ok find('#start_enroll')
      find('#start_enroll').click()
    ), 500
  )

  andThen( ->
    expectElement('#generated_mnemonic')
    find('#qr_switcher').click()
  )

  andThen( ->
    expectElement('#generated_mnemonic_qr')
    find('#done_mnemonics').click()
  )

  andThen( ->
    expectElement('#pass_input')
    expectNoElement('#submit-passphrase')
    find('#pass_input > input').val('foo').trigger('focusout')
  )

  andThen( ->
    expectElement('#pass_input.has-error')
    find('#pass_input > input').val(TESTPASS).trigger('focusout')
  )

  andThen( ->
    expectElement('#pass_input.has-success')
    find('#pass_check > input').val(TESTPASS).trigger('focusout')
  )

  andThen(->
    expectElement('#submit-passphrase')
    find('#submit-passphrase').click()
  )

  andThen(->
    expectElement('#enroll-progress')
  )