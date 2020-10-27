const { environment } = require('@rails/webpacker')
const resolverConfig = require('./resolver')

environment.config.merge(resolverConfig)

module.exports = environment