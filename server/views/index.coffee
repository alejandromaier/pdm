fs = require 'fs'
{resolve} = require 'path'

views = {}

for dir in fs.readdirSync('views')
  if fs.statSync(resolve 'views', dir).isDirectory()
    views[dir] = {}
    for file in fs.readdirSync(resolve 'views', dir)
      name = file.split('.')[0]
      views[dir][name] = require("./#{dir}/#{name}")

module.exports = views
