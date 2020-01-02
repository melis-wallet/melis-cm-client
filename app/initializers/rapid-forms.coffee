import EmFormGroup from 'ember-rapid-forms/components/em-form-group'


CmSessionInitializer = {
  name: 'rapid-forms-custom'

  initialize: (application) ->
    EmFormGroup.reopen(
      successIcon: 'check-square'
      errorIcon: 'square'
    )


}

export default CmSessionInitializer