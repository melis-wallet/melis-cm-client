import LinkActionMixin from '../mixins/link-action'

{ LinkComponent } = Ember

LinkActionInitializer = {
  name: 'allow-link-action'

  initialize: (application) ->
    LinkComponent.reopen(LinkActionMixin)

}

export default LinkActionInitializer