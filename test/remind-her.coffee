assert = (require 'chai').assert

process.env.TZ = 'UTC'

Helper = require 'hubot-test-helper'
helper = new Helper('../scripts')

lastRoom = null

createRoom = () ->
  if lastRoom
    lastRoom.robot.shutdown()
  room = helper.createRoom()
  lastRoom = room
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
    assert.match room.lastMessage(), /I'll remind you to foo/

  it 'subject is optional', ->
    room.user.say 'user', 'hubot remind 5 PM to foo'
    assert.match room.lastMessage(), /I'll remind you to foo/

  it 'for can be used in place of to', ->
    room.user.say 'user', 'hubot remind me on 5 PM for stuff'
    assert.match room.lastMessage(), /I'll remind you for stuff/

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
    assert.match room.lastMessage(), /I'll remind you to do task Tomorrow at 5:00 PM/

describe 'Listing reminders', ->
  it 'when no reminders', ->
    room = createRoom()
    room.user.say 'user', 'hubot list reminders'
    assert.equal room.lastMessage(), 'No reminders'

  it 'alternate syntax', ->
    room = createRoom()
    room.user.say 'user', 'hubot list remind'
    assert.equal room.lastMessage(), 'No reminders'
    room.user.say 'user', 'hubot show reminders'
    assert.equal room.lastMessage(), 'No reminders'
    room.user.say 'user', 'hubot reminders list'
    assert.equal room.lastMessage(), 'No reminders'

  it "when reminder exists, they're sorted by time", ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at 5 PM to do task2'
    room.user.say 'user', 'hubot remind me at 4 PM to do task1'
    room.user.say 'user', 'hubot list reminders'
    items = ['1. to do task1 at Today at 4:00 PM',
             '2. to do task2 at Today at 5:00 PM']
    assert.equal room.lastMessage(), items.join '\n'

  it "reminders for each user and room are separate", ->
    room1 = createRoom()
    room1.user.say 'user', 'hubot remind me at 4 PM to do task1'
    room2 = createRoom()
    room2.user.say 'user', 'hubot remind me at 4 PM to do task2'
    room1.user.say 'user', 'hubot list reminders'
    assert.match room1.lastMessage(), /task1/
    room2.user.say 'user', 'hubot list reminders'
    assert.match room2.lastMessage(), /task2/
