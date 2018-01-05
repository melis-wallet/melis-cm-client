`import Ember from 'ember'`


DownloadProperty = Ember.Component.extend(

  device: Ember.inject.service('device-support')

  tagName: 'span'
  icon: 'fa fa-cloud-download'
  btnClass: null

  data: null
  filename: null
  additionalInfo: null

  dataUri: (->
    'data:application/json;charset=UTF-8,' + encodeURIComponent(JSON.stringify(@get('data')))
  ).property('data')


  actions:
    mobileSend: ->
      @get('device').mailFile(
        @get('filename'),
        @get('filename'),
        @get('additionalInfo').toString(),
        JSON.stringify(@get('data'))
      ).then( -> Ember.Logger.debug('Mail Sent'))
)


`export default DownloadProperty`
