import Ptx from 'melis-cm-svcs/models/ptx'

ClientPtx = Ptx.extend(

  signIcon: (->
    switch
      when @get('isInvalid')
        'fa fa-exclamation-triangle'
      when @get('isBroadcasted')
        'fa fa-check'
      when @get('isCanceled')
        'fa fa-trash'
      when @get('accountCanSign')
        'fa fa-pencil'
      when @get('isActive')
        'fa fa-users'
      else
         'fa fa-times'
  ).property('cmo', 'accountCanSign')

  signIconClass: (->
    switch
      when @get('isInvalid')
        'label-danger'
      when @get('isBroadcasted')
        'label-success'
      when @get('accountCanSign')
        'label-warning'
      when @get('isActive')
        'label-info'
      else
        null
  ).property('cmo', 'accountCanSign')

)

export default ClientPtx
