module.exports.MONGO_URI = process.env.MONGO_URI or 'mongodb://localhost/stockversus'
module.exports.ALPHA_VANTAGE_KEY = process.env.ALPHA_VANTAGE_KEY or 'O7B5'
module.exports.POLLING_INTERVAL = process.env.POLLING_INTERVAL or 1 * 60 * 1000 # 1 minute