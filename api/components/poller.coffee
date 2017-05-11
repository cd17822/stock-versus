_ = require 'lodash'
rek = require 'rekuire'
Stock = rek 'models/stock'
Share = rek 'models/share'
Portfolio = rek 'models/portfolio'
market = rek 'components/market'
configs = rek 'config'

module.exports.start = ->
  setInterval ->
    # 0 is sunday for Date.prototype.getDay()
    now = new Date()

    # update historical portfolio balances
    if now.getDay() > 0 and now.getDay() < 6 and (now.getHours() == 9 and now.getMinutes() == 30)
      Portfolio.find {}, (err, portfolios) ->
        if err then console.log err
        else
          for portfolio in portfolios
            portfolio.balance_d = portfolio.balance
            if now.getDay() == 1
              portfolio.balance_w = portfolio.balance
            if now.getDate() == 1
              portfolio.balance_m = portfolio.balance
              if now.getMonth() % 3 == 0
                portfolio.balance_q = portfolio.balance
                if now.getMonth() == 0
                  portfolio.balance_y = portfolio.balance
            portfolio.save (err, portfolio) ->
              if err then console.log err

    # update stock balances (and eventually current balance for portfolio)
    if yes #now.getDay() > 0 and now.getDay() < 6 and (now.getHours() == 9 and now.getMinutes() >= 30) or (now.getHours() > 9 and now.getHours < 16) or (now.getHours() == 16 and now.getHours() == 0)
      Stock.find {}, (err, stocks) ->
        if err then console.log err
        else
          hits = 0
          for stock in stocks
            if yes #now.getHours() == 9 and now.getMinutes() == 30 # opening bell
              market.getStockHistory stock.ticker, stock, (err, stock, stockPieces) ->
                if err then console.log err
                else updateStockWithNewPieces stock, stockPieces
            else # a minute during trading hours that isn't 9:30
              market.getStockNow stock.ticker, stock, (err, stock, stockPieces) ->
                if err then console.log err
                else updateStockWithNewPieces stock, stockPieces

          updateStockWithNewPieces = (stock, pieces) ->
            # need to preserve id
            for key in _.keys pieces
              stock[key] = pieces[key]
            stock.save (err, stock) ->
              if err then console.log err
              else
                hits += 1
                tryUpdatingPortfolios()

          tryUpdatingPortfolios = ->
            if hits == stocks.length
              Portfolio.find {}, (err, portfolios) ->
                if err then console.log err
                else
                  hits = 0
                  for portfolio in portfolios
                    portfolio.balance = portfolio.cash
                    portfolio.save (err, p) ->
                      if err then console.log err
                      else
                        hits += 1
                        tryMoveOnToShares()

                  tryMoveOnToShares = ->
                    if hits == portfolios.length
                      Share.find().populate('stock').exec (err, shares) ->
                        if err then console.log err
                        else
                          for share in shares
                            inc = if share.buy then share.shares * share.stock.balance else share.shares * (2 * share.balance_a - share.stock.balance)
                            Portfolio.findByIdAndUpdate share.portfolio, {$inc: {balance: inc}}, (err, portfolio) ->
                              if err then console.log err

  , configs.POLLING_INTERVAL
