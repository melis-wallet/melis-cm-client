import StreamEntry from 'melis-cm-svcs/models/stream-entry'
import { dasherize } from '@ember/string';

ClientStreamEntry = StreamEntry.extend(

  eventIcon:  (->

    switch @get('subclass')
      when 'ptx'
        'cm-icon cmi-receipt'
      when 'txinfo'
        if @get('content.negative')
          'cm-icon cmi-wallet'
        else
          'cm-icon cmi-cash-dollar'
      when 'address'
        'cm-icon cmi-barcode'
      else
          'cm-icon cmi-notification-circle'

  ).property('subclass', 'content')


  multiIcon: ( ->
    switch @get('subclass')
      when 'ptx'
        if @get('content.isMultisig')
          'cm-icon cmi-acc-multi'
        else
          'cm-icon cmi-acc-sing'

  ).property('subclass', 'content')

  contentType: ( ->
    dasherize(@get('content.type')) if @get('content.type')
  ).property('content.type')
)

export default ClientStreamEntry
