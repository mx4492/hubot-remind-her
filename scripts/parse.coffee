# Export a parse method that builds on top of the chrono date parser
# and tries to extract a date and an action from a given string.

chrono = require('chrono-node')

# Return a Date on success, and false on failure.

parse = (s) ->
  res = chrono.parse s
  if res.length == 0
    return false
  res[0].start.date()

module.exports = parse
