_ = require 'lodash'
mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
idValidator = require 'mongoose-id-validator'

schema = mongoose.Schema
  name: String
  password: String
  cash: Number
  balance: Number
  balance_d: Number
  balance_w: Number
  balance_m: Number
  balance_q: Number
  balance_y: Number
  ranking_d: Number
  ranking_w: Number
  ranking_m: Number
  ranking_q: Number
  ranking_y: Number
  ranking_a: Number
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'user'}

schema.set 'toJSON', transform: (doc, ret, options) ->
  _.pick doc, 'id', 'name', 'password', 'cash', 'balance', 'balance_d', 'balance_w', 'balance_m', 'balance_q', 'balance_y', 'ranking', 'ranking_d', 'ranking_w', 'ranking_m', 'ranking_q', 'ranking_y', 'ranking_a', 'user', 'buys', 'puts', 'created_at'

schema.plugin idValidator, message : 'Invalid {PATH}.'
schema.plugin timestamps, createdAt: 'created_at', updatedAt: 'updated_at'

# validation
(schema.path 'name').validate (val) ->
  val?.length <= 50
, 'Name is too long.'

# santization
(schema.path 'name').set (val) -> val.trim()

module.exports = User = mongoose.model 'portfolio', schema
