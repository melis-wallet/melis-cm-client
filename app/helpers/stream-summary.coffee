`import Ember from 'ember'`

StreamSummary = Ember.Helper.extend(

  i18n: Ember.inject.service()
  cm:  Ember.inject.service('cm-session')
  coinsvc: Ember.inject.service('cm-coin')

  compute: (params, hash) ->
    entry = params[0]
    what = hash.what || 'title'

    length = hash.length || 40

    account = Ember.get(entry, 'account')
    i18n = @get('i18n')

    svc = @get('coinsvc')

    switch Ember.get(entry, 'subclass')
      when 'ptx'
        amount = Ember.get(entry, 'content.cmo.amount')
        title = svc.formatUnit(account, amount) + ' ' + account.get('subunit.symbol').toLowerCase()
        caption = i18n.t('stream.helper.ptx.caption', by: account.cosignerName( Ember.get(entry, 'content.cmo.accountPubId'), you: i18n.t('tx.you'), keyIsFine: false  ))
      when 'txinfo'
        title = i18n.t('stream.helper.txinfo.title')
        caption = i18n.t('stream.helper.txinfo.caption')

      when 'address'
        title = Ember.get(entry, 'content.cmo.meta.info') || i18n.t('stream.helper.address.title')
        if amount = Ember.get(entry, 'content.cmo.meta.amount')
          caption = svc.formatUnit(account, amount) + ' ' + account.get('subunit.symbol').toLowerCase()



    switch what
      when 'title'
        return title?.toString().substring(0, Math.min(length, title.length)) if title
      when 'caption'
        return caption?.toString().substring(0, Math.min(length, caption.length)) if caption

)

`export default StreamSummary`