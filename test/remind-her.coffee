assert = (require 'chai').assert

process.env.TZ = 'UTC'

Helper = require 'hubot-test-helper'
helper = new Helper('../scripts')

createRoom = () ->
  room = helper.createRoom()
  room.lastMessage = ->
    [..., last] = @messages
    last[1]
  room

describe 'Reminder Strings', ->
  room = null
  beforeEach ->
    room = createRoom()

  it 'that do not specify a date are ignored', ->
    room.user.say 'user', 'hubot remind me at not a date to do task'
    assert.match room.lastMessage(), /I did not understand the date/

  it 'can be absolute chrono formats specified with "at"', ->
    room.user.say 'user', 'hubot remind me at tomorrow 5 PM to foo'
    assert.match room.lastMessage(), /I'll remind you to foo/

  it 'can be relative chrono formats specified with "in"', ->
    room.user.say 'user', 'hubot remind me in 15 minutes to foo'
    assert.match room.lastMessage(), /I'll remind you to foo at/

  it 'subject is optional', ->
    room.user.say 'user', 'hubot remind 5 PM to foo'
    assert.match room.lastMessage(), /I'll remind you to foo at/

describe 'Output Format', ->
  it 'uses moment.js outputs', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind Saturday, 17 August 2513 to do task'
    # http://momentjs.com/docs/#/displaying/calendar-time/
    assert.match room.lastMessage(), /08\/17\/2513/

describe 'Input/Output Functional test', ->
  it 'relative dates work in both input and output', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at tomorrow 5 PM to do task'
    assert.match room.lastMessage(), /I'll remind you to do task at Tomorrow at 5:00 PM/
