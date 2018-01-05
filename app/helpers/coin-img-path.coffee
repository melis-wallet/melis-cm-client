`import Ember from 'ember'`

PATH = 'images/icons/*-icon.svg'

CoinImgPath =  Ember.Helper.helper((params) ->
  coin = params[0]
  PATH.replace('*', coin?.toLowerCase())
)

`export default CoinImgPath`