_ = require 'lodash'
router = (require 'express').Router()
rek = require 'rekuire'
Portfolio = rek 'models/portfolio'
User = rek 'models/user'

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

module.exports = router
