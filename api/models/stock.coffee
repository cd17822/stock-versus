_ = require 'lodash'
mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
idValidator = require 'mongoose-id-validator'

schema = mongoose.Schema
  name: String
  ticker: String
  balance: Number
  balance_d: Number
  balance_w: Number
  balance_m: Number
  balance_q: Number
  balance_y: Number
  num_portfolios: Number

schema.set 'toJSON', transform: (doc, ret, options) ->
  _.pick doc, 'id', 'name', 'ticker', 'balance', 'balance_d', 'balance_w', 'balance_m', 'balance_q', 'balance_y', 'num_portfolios', 'created_at'

schema.plugin idValidator, message : 'Invalid {PATH}.'
schema.plugin timestamps, createdAt: 'created_at', updatedAt: 'updated_at'

# validation
# (none)

# santization
# (none)

module.exports = User = mongoose.model 'stock', schema
