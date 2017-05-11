_ = require 'lodash'
mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
idValidator = require 'mongoose-id-validator'

schema = mongoose.Schema
  stock: {type: mongoose.Schema.Types.ObjectId, ref: 'stock'}
  ticker: String # technically could just get it from stock but have it here too for convenience
  balance_a: Number
  shares: Number
  buy: Boolean
  portfolio: {type: mongoose.Schema.Types.ObjectId, ref: 'portfolio'}

schema.set 'toJSON', transform: (doc, ret, options) ->
  _.pick doc, 'id', 'shares', 'stock', 'balance_a', 'portfolio', 'buy', 'created_at'

schema.plugin idValidator, message : 'Invalid {PATH}.'
schema.plugin timestamps, createdAt: 'created_at', updatedAt: 'updated_at'

# validation
# (none)

# santization
# (none)

module.exports = User = mongoose.model 'share', schema
