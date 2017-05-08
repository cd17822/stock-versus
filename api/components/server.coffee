module.exports.sendError = (res, status, type, message, params) ->
  (res.status status).send error: type: type, message: message, params: params
