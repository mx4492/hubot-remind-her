# Description:
#   Friendly reminders for hubot
#
# Commands:
#   hubot remind me tomorrow to document this better
#   hubot remind us in 15 minutes to end this meeting
#   hubot remind at 5 PM to go home
#   hubot list remind[ers]
#   hubot show remind[ers]
#   hubot remind[ers] (list|show)
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

envelope_key = (e) -> e.room || e.user.id

class Reminders
  constructor: (@robot) ->
    @pending = {}
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

    after = reminder.diff()
    @robot.logger.debug("add id: #{id} after: #{after}")

    setTimeout =>
      @fire(id, reminder)
    , after

    k = reminder.key()
    (@pending[k] ?= []).push reminder
    (@pending[k]).sort (r1, r2) -> r1.diff() - r2.diff()
    @robot.brain.data.reminder_at[id] = reminder

  fire: (id, reminder) ->
    @robot.reply reminder.envelope, "You asked me to remind you #{reminder.action}"
    @remove(id)

  remove: (id) ->
    @robot.logger.debug("remove id:#{id}")
    delete @robot.brain.data.reminder_at[id]

  list: (msg) ->
    k = envelope_key msg.envelope
    @robot.logger.debug("listing reminders for #{k}")
    p = @pending[k]
    unless p
      "No reminders"
    else
      lines = ("#{i+1}. #{r.action} at #{r.prettyDate()}" for r, i in p)
      lines.join('\n')

class ReminderAt

  constructor: (@envelope, @date, @action) ->

  key: -> envelope_key @envelope

  diff: ->
    now = new Date().getTime()
    (@date.getTime()) - now

  prettyDate: ->
    moment(@date).calendar()

module.exports = (robot) ->
  reminders = new Reminders robot

  robot.respond /remind (.+) ((to|for).*)/i, (msg) ->
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

    msg.send "I'll remind you #{action} #{reminder.prettyDate()}"

  robot.respond /(list|show) remind(ers)?/i, (msg) ->
    msg.send reminders.list(msg)

  robot.respond /remind(ers)? (list|show)/i, (msg) ->
    msg.send reminders.list(msg)
