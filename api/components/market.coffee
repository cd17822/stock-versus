request = require 'request'
_ = require 'lodash'
rek = require 'rekuire'
configs = rek 'config'
Stock = rek 'models/stock'

module.exports.getStockNow = (ticker, cb) ->
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get onfleet task: #{JSON.stringify body}"
      else
        stock = new Stock()
        stock.ticker = ticker
        stock.balance = Number _.values(_.values(body['Time Series (1min)'])[0])[0]
        stock.num_portfolios = 0
        
        cb null, stock
