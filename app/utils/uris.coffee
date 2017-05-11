`import Ember from 'ember'`

#kind of naive
URL_REGEXP = /^([A-Za-z0-9\+]+):([A-Za-z0-9\-\.]+)(?:\?(.*))?$/


parseURI = (data) ->

  match = URL_REGEXP.exec(data)

  res = {data}
  if match
    res.scheme = match[1]
    res.address = match[2]
    res.queries = {}
    if match[3]
      queries = match[3].split('&')
      for i in [0..(queries.length-1)]
        query = queries[i].split('=')
        if (query.length == 2)
          res.queries[query[0]] = decodeURIComponent(query[1])

  res



`export { parseURI }`