`import EmFormGroup from 'ember-rapid-forms/components/em-form-group'`


CmSessionInitializer = {
  name: 'rapid-forms-custom'

  initialize: (application) ->
    EmFormGroup.reopen(
      successIcon: 'fa fa-check-square'
      errorIcon: 'fa fa-square'
    )


}

`export default CmSessionInitializer`