assert = require 'assert'
parse = require '../scripts/parse'

process.env.TZ = 'UTC'

describe 'Parser', ->
  it 'ignores strings that do not specific a date', ->
    res = parse 'something'
    assert.equal false, res

  it 'parses strings that chrono vanilla parses', ->
    # Example taken from http://wanasit.github.io/pages/chrono/
    res = parse 'tomorrow'
    assert res
    assert (res instanceof Date)
