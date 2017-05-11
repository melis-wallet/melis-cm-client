`import BaseValidator from 'ember-cp-validations/validators/base'`

DUPLICATE_ALIAS = 'validations.duplicate-alias'

UniqueAlias = BaseValidator.extend
  cm: Ember.inject.service('cm-session')
  i18n: Ember.inject.service()

  validate: (value, options, model, attribute) ->
    return true if Ember.isBlank(value) && options.allowBlank

    @get('cm.api').aliasIsAvailable(value).then((res) =>
      if res && res.avail
        return true
      else
        return @get('i18n').t(DUPLICATE_ALIAS).toString()

    )



`export default UniqueAlias`