chai = require 'chai'
assert = require 'assert'

process.env.TZ = 'UTC'

Helper = require 'hubot-test-helper'
helper = new Helper('../scripts')

describe 'Reminder formats', ->
  room = null
  beforeEach ->
    room = helper.createRoom()

  it 'chrono formats specified with "at" are parsed', ->
    # Example taken from http://wanasit.github.io/pages/chrono/
    room.user.say 'user', 'hubot remind me at Saturday, 17 August 2513 to do task'
    assert.deepEqual ["hubot", "I'll remind you to do task at Thu Aug 17 2513 12:00:00 GMT+0000 (UTC)"], room.messages[1]
