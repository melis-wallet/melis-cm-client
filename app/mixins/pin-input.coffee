import Mixin from '@ember/object/mixin'

PinInput = Mixin.create(

  tryLastAttempt: false

  loginLocked: (->
    @get('credentials.attemptsLeft') == 0
  ).property('credentials.attemptsLeft')


  lowAttempts: (->
    left = @get('credentials.attemptsLeft')
    (left == 1)
  ).property('credentials.attemptsLeft')
)

export default PinInput
