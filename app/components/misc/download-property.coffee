import Component from '@ember/component'
import { inject as service } from '@ember/service'

import Logger from 'melis-cm-svcs/utils/logger'


DownloadProperty = Component.extend(

  device: service('device-support')

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
      ).then( -> Logger.debug('Mail Sent'))
)


export default DownloadProperty
