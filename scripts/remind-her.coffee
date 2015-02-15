# Description:
#   Friendly reminders for hubot
#
# Commands:
#   hubot remind me tomorrow to document this better
#   hubot remind us in 15 minutes to end this meeting
#   hubot remind at 5 PM to go home
#
# Notes:
#   For help with the time string syntax, see
#   http://wanasit.github.io/pages/chrono/

chrono = require 'chrono-node'
uuid = require 'node-uuid'
moment = require 'moment'

# Method that builds on top of the chrono date parser and tries to
# extract a date and an action from a given string.
#
# Return a Date on success, and false on failure.

parse = (s) ->
  res = chrono.parse s
  if res.length == 0
    return false
  res[0].start.date()

class Reminders
  constructor: (@robot) ->
    @robot.brain.data.reminder_at ?= {}
    @robot.brain.on 'loaded', =>
        reminder_at = @robot.brain.data.reminder_at
        for own id, o of reminder_at
          reminder = new ReminderAt o.envelope, new Date(o.date), o.action
          if reminder.diff() > 0
            @queue(reminder, id)
          else
            @remove(id)

  queue: (reminder, id) ->

    if ! id?
      id = uuid.v4() while ! id? or @robot.brain.data.reminder_at[id]

    @robot.logger.debug("add id:#{id}")

    @robot.logger.info(reminder.diff())
    setTimeout =>
      @robot.reply reminder.envelope, "you asked me to remind you to #{reminder.action}"
      @remove(id)
    , reminder.diff()

    @robot.brain.data.reminder_at[id] = reminder

  remove: (id) ->
    @robot.logger.debug("remove id:#{id}")
    delete @robot.brain.data.reminder_at[id]

class ReminderAt

  constructor: (@envelope, @date, @action) ->

  diff: ->
    now = new Date().getTime()
    (@date.getTime()) - now

module.exports = (robot) ->
  reminders = new Reminders robot

  robot.respond /remind (.+) to (.*)/i, (msg) ->
    text = msg.match[0]
    action = msg.match[2]

    date = parse text

    if date == false
      msg.send "I did not understand the date in '#{text}'"
      return

    reminder = new ReminderAt msg.envelope, date, action

    @robot.logger.debug date

    if reminder.diff() <= 0
      msg.send "#{date} is past. can't remind you"
      return

    reminders.queue reminder

    outputDate = moment(date).calendar()
    msg.send "I'll remind you to #{action} at #{outputDate}"
