Fs = require 'fs'
Path = require 'path'

module.exports = (robot) ->
  path = Path.resolve __dirname, 'scripts'
  robot.loadFile path, file for file in Fs.readdirSync(path)
