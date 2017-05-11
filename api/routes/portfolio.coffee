_ = require 'lodash'
router = (require 'express').Router()
rek = require 'rekuire'
Portfolio = rek 'models/portfolio'
User = rek 'models/user'
Stock = rek 'models/stock'
Share = rek 'models/share'
market = rek 'components/market'

# get portfolios of a user
router.get '/:userId', (req, res, next) ->
  Portfolio.find user: req.params.userId, (err, portfolios) ->
    if err then next err
    else
      hits = 0
      for i in [0...portfolios.length]
        portfolio = portfolios[i]
        Share.find(portfolio: portfolio.id).populate('stock').exec (err, shares) ->
          if err then next err
          else
            portfolio.buys = []
            portfolio.puts = []
            for s in shares
              if s.buy then portfolio.buys.push s
              else          portfolio.puts.push s

            hits += 1
            tryToCallback()

      tryToCallback = ->
        if hits == portfolios.length
          res.send portfolios: portfolios

# create new portfolio
router.post '/', (req, res, next) ->
  portfolio = new Portfolio _.pick req.body, 'name', 'balance', 'cash'

  User.findOne username: req.body.username, (err, user) ->
    if err then next err
    else
      if not user then (res.status 400).send error: 'could not locate user'
      else
        portfolio.user = user

        portfolio.balance_d = req.body.balance
        portfolio.balance_w = req.body.balance
        portfolio.balance_m = req.body.balance
        portfolio.balance_q = req.body.balance
        portfolio.balance_y = req.body.balance
        portfolio.balance_a = req.body.balance

        # these will have to change
        portfolio.ranking_d = 0
        portfolio.ranking_w = 0
        portfolio.ranking_m = 0
        portfolio.ranking_q = 0
        portfolio.ranking_y = 0
        portfolio.ranking_a = 0

        portfolio.save (err, user) ->
          if err then next err
          else (res.status 201).send portfolio: portfolio

# place order for a portfolio
router.put '/order', (req, res, next) ->
  Stock.findOneAndUpdate {ticker: req.body.ticker}, {$inc: {num_portfolios: 1}}, (err, stock) ->
    if err then next err
    else
      if not stock
        market.getStockHistory req.body.ticker, null, (err, s, stockPieces) ->
          if err then next err
          else
            stock = new Stock _.pick stockPieces, 'ticker', 'balance', 'balance_d', 'balance_w', 'balance_m', 'balance_q', 'balance_y'
            stock.num_portfolios = 1

            stock.save (err, stock) ->
              if err then next err
              else
                share = new Share()
                share.stock = stock.id
                share.ticker = stock.ticker
                share.balance_a = stock.balance
                share.portfolio = req.body.portfolio
                share.buy = req.body.buy
                share.shares = req.body.shares

                share.save (err, share) ->
                  if err then next err
                  else
                    inc_by = -1*share.shares*stock.balance
                    Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: inc_by}}, (err, portfolio) ->
                      if err then next err
                      else
                        Share.find(portfolio: portfolio.id).populate('stock').exec (err, shares) ->
                          if err then next err
                          else
                            portfolio.buys = []
                            portfolio.puts = []
                            for s in shares
                              if s.buy then portfolio.buys.push s
                              else          portfolio.puts.push s
                            (res.status 201).send portfolio: portfolio
      else
        share = new Share()
        share.stock = stock.id
        share.ticker = stock.ticker
        share.balance_a = stock.balance
        share.portfolio = req.body.portfolio
        share.buy = req.body.buy
        share.shares = req.body.shares

        share.save (err, share) ->
          if err then next err
          else
            inc_by = -1*share.shares*stock.balance
            Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: inc_by}}, (err, portfolio) ->
              if err then next err
              else
                Share.find(portfolio: portfolio.id).populate('stock').exec (err, shares) ->
                  if err then next err
                  else
                    portfolio.buys = []
                    portfolio.puts = []
                    for s in shares
                      if s.buy then portfolio.buys.push s
                      else          portfolio.puts.push s
                    (res.status 201).send portfolio: portfolio

module.exports = router
