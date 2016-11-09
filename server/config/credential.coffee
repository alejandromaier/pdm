credential = require 'credential'
Promise = require 'bluebird'
pw = credential()

module.exports =
  hash: Promise.promisify(pw.hash)
  verify: Promise.promisify(pw.verify)
