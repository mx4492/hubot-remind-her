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

describe 'Date parsing', ->
  parse = (s) ->
    room = createRoom()
    room.user.say 'user', "hubot remind me at #{s} to do task"
    room.lastMessage()

  it 'time tomorrow', ->
    assert.match parse('tomorrow 5 PM'), /Tomorrow at 5:00 PM/

  it 'time that has passed today', ->
    assert.match parse('00:1 AM'), /Tomorrow at 12:01 AM/

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
    room.user.say 'user', 'hubot reminders all'
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

describe 'Deleting reminders', ->
  it 'when no reminders', ->
    room = createRoom()
    room.user.say 'user', 'hubot delete remind 1'
    assert.match room.lastMessage(), /No reminders/

  it 'alternate syntax', ->
    room = createRoom()
    room.user.say 'user', 'hubot remove remind 1'
    assert.match room.lastMessage(), /No reminders/
    room.user.say 'user', 'hubot stop reminders 1'
    assert.match room.lastMessage(), /No reminders/
    room.user.say 'user', 'hubot reminders delete 1'
    assert.match room.lastMessage(), /No reminders/
    room.user.say 'user', 'hubot reminders remove 1'
    assert.match room.lastMessage(), /No reminders/
    room.user.say 'user', 'hubot reminders stop 1'
    assert.match room.lastMessage(), /No reminders/

  it 'out of bounds index', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at 4 PM to do task'
    room.user.say 'user', 'hubot delete remind 2'
    assert.match room.lastMessage(), /No such reminder/

  it 'deleted reminders are not listed', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at 4 PM to do task'
    room.user.say 'user', 'hubot delete remind 1'
    assert.match room.lastMessage(), /Removed reminder #1/
    room.user.say 'user', 'hubot list reminders'
    assert.equal room.lastMessage(), 'No reminders'

describe 'Repeating reminders', ->
  it 'when no reminders', ->
    room = createRoom()
    room.user.say 'user', 'hubot repeat remind 1'
    assert.match room.lastMessage(), /No reminders/

  it 'alternate syntax', ->
    room = createRoom()
    room.user.say 'user', 'hubot reminder repeat 1'
    assert.match room.lastMessage(), /No reminders/
    room.user.say 'user', 'hubot reminders repeat 1'
    assert.match room.lastMessage(), /No reminders/

  it 'out of bounds index', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at 4 PM to do task'
    room.user.say 'user', 'hubot repeat reminder 2'
    assert.match room.lastMessage(), /No such reminder/

  it 'repeated reminders are listed differently', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me at 4 PM to do task'
    room.user.say 'user', 'hubot repeat reminder 1'
    assert.match room.lastMessage(), /Will repeat reminder #1/
    room.user.say 'user', 'hubot list reminders'
    assert.match room.lastMessage(), /task .* \(repeated\)$/

  it 'repeated reminders using inline specification', ->
    room = createRoom()
    room.user.say 'user', 'hubot remind me every 4 PM to do task'
    assert.match room.lastMessage(), /remind you every/
    room.user.say 'user', 'hubot remind every 4 PM to task'
    assert.match room.lastMessage(), /remind you every/
    room.user.say 'user', 'hubot remind 4 PM to do every task'
    assert.notMatch room.lastMessage(), /remind you every/
