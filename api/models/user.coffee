_ = require 'lodash'
mongoose = require 'mongoose'
timestamps = require 'mongoose-timestamp'
idValidator = require 'mongoose-id-validator'
bcrypt = require 'bcrypt'

schema = mongoose.Schema
  first_name: String
  last_name: String
  email: String
  phone: String
  password: String

schema.set 'toJSON', transform: (doc, ret, options) ->
  _.pick doc, 'id', 'first_name', 'last_name', 'email', 'phone', 'created_at'

schema.pre 'save', (next) ->
  #hash password
  if @isModified 'password' then @password = bcrypt.hashSync @password, bcrypt.genSaltSync 10
  next()

schema.plugin idValidator, message : 'Invalid {PATH}.'
schema.plugin timestamps, createdAt: 'created_at', updatedAt: 'updated_at'

# validation
(schema.path 'first_name').required yes, 'First name is required.'

(schema.path 'first_name').validate (val) ->
  val?.length > 1
,'First name is too short.'

(schema.path 'first_name').validate (val) ->
  val?.length <= 100
, 'First name is too long.'

(schema.path 'last_name').required yes, 'Last name is required.'

(schema.path 'last_name').validate (val) ->
  val?.length > 1
,'Last name is too short.'

(schema.path 'last_name').validate (val) ->
  val?.length <= 100
, 'Last name is too long.'

(schema.path 'email').required yes, 'Email name is required.'

(schema.path 'email').unique yes

(schema.path 'email').validate (val) ->
  /\S+@\S+\.\S+/.test(val)
, 'Invalid email address.'

(schema.path 'phone').required yes, 'Phone number is required.'

(schema.path 'phone').validate (val) ->
  /^[0-9]+$/.test(val)
, 'Invalid phone number.'

(schema.path 'phone').validate (val) ->
  val?.length <= 50 and val?.length > 6
, 'Invalid phone number.'

(schema.path 'password').required yes, 'Password is required.'

(schema.path 'password').validate (val) ->
  val?.length > 5
,'Passwords must have at least 6 characters.'

(schema.path 'password').validate (val) ->
  val?.length <= 100
,'Password is too long.'

# santization
(schema.path 'first_name').set (val) -> val.trim()
(schema.path 'last_name').set (val) -> val.trim()
(schema.path 'email').set (val) -> val.trim().toLowerCase()

module.exports = User = mongoose.model 'user', schema

# validate email unique
(schema.path 'email').validate (val, respond) ->
  if not @isNew then respond yes
  else User.findOne email: val, (err, user) ->
    if err or user then respond no
    else respond yes
, 'This email address is already registered.'
