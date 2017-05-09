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
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock = new Stock()
        stock.ticker = ticker
        stock.balance = Number _.values(_.values(body['Time Series (1min)'])[0])[0]
        stock.num_portfolios = 0
        
        cb null, stock

module.exports.getStockHistory = (ticker, cb) ->
  hits = 0
  stock = new Stock()

  # now
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock.balance = Number (_.values(body['Time Series (1min)'])[0])["4. close"]
        hits += 1
        tryCallingBack()

  # day
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock.balance_d = Number (_.values(body['Time Series (Daily)'])[1])["4. close"]
        hits += 1
        tryCallingBack()
  
  # week
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock.balance_w = Number (_.values(body['Weekly Time Series'])[1])["4. close"]
        hits += 1
        tryCallingBack()      
  
  # month and year
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock.balance_m = Number (_.values(body['Monthly Time Series'])[0])["4. close"]
        stock.balance_y = Number (_.values(body['Monthly Time Series'])[(new Date).getMonth()+1])["4. close"]
        hits += 1
        tryCallingBack()

  tryCallingBack = ->
    if hits == 4
      cb null, stock

