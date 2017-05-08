_ = require 'lodash'
router = (require 'express').Router()
rek = require 'rekuire'
Stock = rek 'models/stock'
market = rek 'components/market'

# create new portfolio
router.get '/:ticker', (req, res, next) ->
  ticker = req.params.ticker
  Stock.findOne ticker: ticker, (err, stock) ->
    if err then next err
    else
      if stock then res.send stock: stock
      else
        market.getStock ticker, (err, stock) ->
          if err then next err
          else res.send stock: stock

module.exports = router
