assert = (require 'chai').assert

process.env.TZ = 'UTC'

Helper = require 'hubot-test-helper'
helper = new Helper('../scripts')

describe 'Reminder Strings', ->
  room = null
  beforeEach ->
    room = helper.createRoom()
    room.lastMessage = ->
      [..., last] = @messages
      last[1]

  it 'can be absolute chrono formats specified with "at"', ->
    room.user.say 'user', 'hubot remind me at Saturday, 17 August 2513 to do task'
    assert.equal "I'll remind you to do task at Thu Aug 17 2513 12:00:00 GMT+0000 (UTC)", room.lastMessage()

  it 'can be relative chrono formats specified with "in"', ->
    room.user.say 'user', 'hubot remind me in 15 minutes to foo'
    assert.match room.lastMessage(), /I'll remind you to foo at/

  it 'subject is optional', ->
    room.user.say 'user', 'hubot remind 5 PM to foo'
    assert.match room.lastMessage(), /I'll remind you to foo at/
