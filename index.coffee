Path = require 'path'

module.exports = (robot) ->
  path = Path.resolve __dirname, 'scripts'
  robot.load path
