import I18nService from 'ember-i18n/services/i18n';

export default I18nService.extend({

  t_ex(ex) {

    if (ex.params && ex.params.i18n) {
      return this.t(ex.params.i18n, ex.params );
    } else {
      return ex.msg
    }
  }


});