chai = require 'chai'
assert = chai.assert

Helper = require 'hubot-test-helper'
helper = new Helper('../scripts')

describe 'Reminder formats', ->
  room = null
  beforeEach ->
    room = helper.createRoom()
    room.lastMessageText = ->
      [...,last] = room.messages
      last[1]

  it 'chrono formats specified with "at" are parsed', ->
    # Example taken from http://wanasit.github.io/pages/chrono/
    room.user.say 'user', 'hubot remind me at Saturday, 17 August 2513 to do task'
    result = room.lastMessageText()
    assert.equal "I'll remind you to do task at Thu Aug 17 2513 12:00:00 GMT+0530 (IST)", result
