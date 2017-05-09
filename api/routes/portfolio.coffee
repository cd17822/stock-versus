_ = require 'lodash'
router = (require 'express').Router()
rek = require 'rekuire'
Portfolio = rek 'models/portfolio'
User = rek 'models/user'
Stock = rek 'models/stock'
Share = rek 'models/share'
market = rek 'components/market'

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
        portfolio.ranking = 0
        portfolio.ranking_d = 0
        portfolio.ranking_w = 0
        portfolio.ranking_m = 0
        portfolio.ranking_q = 0
        portfolio.ranking_y = 0
        portfolio.ranking_a = 0

        portfolio.save (err, user) ->
          if err then next err
          else 
            console.log portfolio
            (res.status 201).send portfolio: portfolio

router.put '/order', (req, res, next) ->
  Share.findOne {ticker: req.body.ticker, portfolio: req.body.portfolio, buy: req.body.buy}, (err, share) ->
    if err then next err
    else 
      if not share
        Stock.findOne ticker: req.body.ticker, (err, stock) ->
          if err then next err
          else 
            if not stock
              market.getStockHistory req.body.ticker, (err, stock) ->
                if err then next err
                else
                  stock.num_portfolios = 1
                  console.log stock
                  stock.save (err, stock) ->
                    if err then next err
                    else
                      share = new Share()
                      share.stock = stock.id
                      share.balance_a = stock.balance
                      share.portfolio = req.body.portfolio
                      share.buy = req.body.buy
                      share.shares = req.body.shares
                      console.log share
                      share.save (err, share) ->
                        if err then next err
                        else
                          console.log share.shares
                          console.log stock.balance
                          console.log "incing by"
                          console.log -1*share.shares*stock.balance
                          Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: -1*share.shares*stock.balance}}, (err, portfolio) ->
                            if err then next err
                            else
                              inc_by = -1*share.shares*stock.balance
                              Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: inc_by}}, (err, portfolio) ->
                                if err then next err
                                else
                                  # i hate that i have to do this manually
                                  portfolio.cash += inc_by
                                  (res.status 201).send portfolio: portfolio
            else
              stock.num_portfolios += 1
              stock.save (err, stock) ->
              if err then next err
              else
                share = new Share()
                share.stock = stock.id
                share.balance_a = stock.balance
                share.portfolio = req.body.portfolio
                share.buy = req.body.buy
                share.shares = req.body.shares
                share.save (err, stock) ->
                  if err then next err
                  else 
                    inc_by = -1*share.shares*stock.balance
                    Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: inc_by}}, (err, portfolio) ->
                      if err then next err
                      else
                        # i hate that i have to do this manually
                        portfolio.cash += inc_by
                        (res.status 201).send portfolio: portfolio
      else
        share.shares += req.body.shares
        share.save (err, stock) ->
          if err then next err
          else 
            inc_by = -1*share.shares*stock.balance
            Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: inc_by}}, (err, portfolio) ->
              if err then next err
              else
                # i hate that i have to do this manually
                portfolio.cash += inc_by
                (res.status 201).send portfolio: portfolio

module.exports = router
