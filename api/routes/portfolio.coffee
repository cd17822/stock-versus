_ = require 'lodash'
router = (require 'express').Router()
rek = require 'rekuire'
Portfolio = rek 'models/portfolio'
User = rek 'models/user'
Stock = rek 'models/stock'
Share = rek 'models/share'

# create new portfolio
router.post '/', (req, res, next) ->
  portfolio = new Portfolio _.pick req.body, 'name', 'balance', 'cash'

  User.findOne username: req.body.username, (err, user) ->
    if err then next err
    else
      portfolio.user = user

      portfolio.save (err, user) ->
        if err then next err
        else (res.status 201).send portfolio: portfolio

# should be a put request
router.post '/order', (req, res, next) ->
  Share.findOne {ticker: req.body.ticker, portfolio: req.body.portfolio, buy: req.body.buy}, (err, share) ->
    if err then next err
    else 
      if not share
        Stock.findOne ticker: req.body.ticker, (err, stock) ->
          if err then next err
          else 
            if not stock
              market.getStockHistory ticker, (err, stock) ->
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
                      share.save (err, stock) ->
                        if err then next err
                        else 
                          Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: -1*share.shares*stock.balance}}, (err, portfolio) ->
                            if err then next err
                            else
                              console.log portfolio
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
                    Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: -1*share.shares*stock.balance}}, (err, portfolio) ->
                      if err then next err
                      else (res.status 201).send portfolio: portfolio
      else
        share.shares += req.body.shares
        share.save (err, stock) ->
          if err then next err
          else 
            Portfolio.findByIdAndUpdate req.body.portfolio, {$inc: {cash: -1*share.shares*stock.balance}}, (err, portfolio) ->
              if err then next err
              else (res.status 201).send portfolio: portfolio

module.exports = router
