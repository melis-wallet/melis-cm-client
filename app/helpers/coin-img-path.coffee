import { helper } from '@ember/component/helper'

PATH = 'images/icons/*-icon.svg'

CoinImgPath = helper((params) ->
  coin = params[0]
  PATH.replace('*', coin?.toLowerCase())
)

export default CoinImgPath