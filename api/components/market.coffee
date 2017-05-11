request = require 'request'
_ = require 'lodash'
rek = require 'rekuire'
configs = rek 'config'
Stock = rek 'models/stock'

# these take optional stock parameters because in poller you need to basically get and pass them
module.exports.getStockNow = (ticker, stock, cb) ->
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock_pieces = {}
        stock_pieces.ticker = ticker
        stock_pieces.balance = Number _.values(_.values(body['Time Series (1min)'])[0])[0]
        stock_pieces.num_portfolios = 0

        cb null, stock, stock_pieces

module.exports.getStockHistory = (ticker, stock, cb) ->
  now = new Date()
  hits = 0
  stock_pieces = {}
  stock_pieces.ticker = ticker

  # now
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}&outputsize=compact"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        stock_pieces.balance = Number (_.values(body['Time Series (1min)'])[0])["4. close"]
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
        if _.values(body['Time Series (Daily)'])[1]
          stock_pieces.balance_d = Number (_.values(body['Time Series (Daily)'])[1])["4. close"]
        else
          stock_pieces.balance_d = Number (_.values(body['Time Series (Daily)'])[0])["1. open"]
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
        if _.values(body['Weekly Time Series'])[1]
          stock_pieces.balance_w = Number (_.values(body['Weekly Time Series'])[1])["4. close"]
        else
          stock_pieces.balance_w = Number (_.values(body['Weekly Time Series'])[0])["1. open"]
        hits += 1
        tryCallingBack()

  # month, quarter, year
  request
    url: "http://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=#{ticker}&interval=1min&apikey=#{configs.ALPHA_VANTAGE_KEY}"
    method: 'GET'
    json: true
    (error, response, body) ->
      if error then cb error
      else if response.statusCode isnt 200 then cb new Error "unable to get task: #{JSON.stringify body}"
      else
        if _.values(body['Monthly Time Series'])[1]
          stock_pieces.balance_m = Number (_.values(body['Monthly Time Series'])[1])["4. close"]
        else
          stock_pieces.balance_m = Number (_.values(body['Monthly Time Series'])[0])["1. open"]

        if _.values(body['Monthly Time Series'])[Math.floor((now.getMonth()+1)/3)*3-1]
          stock_pieces.balance_q = Number (_.values(body['Monthly Time Series'])[Math.floor((now.getMonth()+1)/3)*3-1])["4. close"]
        else
          stock_pieces.balance_q = Number (_.values(body['Monthly Time Series'])[_.values(body['Monthly Time Series']).length - 1])["1. open"]

        if _.values(body['Monthly Time Series'])[now.getMonth()+1]
          stock_pieces.balance_y = Number (_.values(body['Monthly Time Series'])[now.getMonth()+1])["4. close"]
        else
          stock_pieces.balance_y = Number (_.values(body['Monthly Time Series'])[_.values(body['Monthly Time Series']).length - 1])["1. open"]

        hits += 1
        tryCallingBack()

  tryCallingBack = ->
    if hits == 4
      cb null, stock, stock_pieces
