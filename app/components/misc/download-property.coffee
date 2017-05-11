`import Ember from 'ember'`


DownloadProperty = Ember.Component.extend(

  tagName: 'span'
  icon: 'fa fa-cloud-download'
  btnClass: null

  data: null
  filename: null


  dataUri: (->
    'data:application/json;charset=UTF-8,' + encodeURIComponent(JSON.stringify(@get('data')))
  ).property('data')
)


`export default DownloadProperty`
