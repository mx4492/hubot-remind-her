# Hubot Remind Her

In her service, this bot will remember everything that she needs to do
but not ask her to speak in weird tongues to get her will be done.

This is a [Hubot][] script. It is a spiritual successor of the
[remind.coffee][] and the [hubot-remind-at][] scripts, combining their
functionality, making the command syntax more flexible, and the bot's
responses more friendly.

## Installation

For now, copy `scripts/hubot-remind-her.coffee` to your scripts
folder.

## Usage

```
Hubot> hubot remind me at tomorrow 7:00 to wakeup!
I'll remind you to wakeup! at Sat Jan 17 2015 07:00:00 GMT+0900 (JST)
```

```
Hubot> Shell: you asked me to remind you to wakeup!
```

The basic commands follow the pattern

    <bot-name> remind me at <time> to <task>

`<time>` can use any reasonable natural language date string. For a
detailed list of possible valid `<time>` strings, see documentation of
the underlying date parsing library, [chrono][].

## Tests

hubot-remind-at comes with a test suite. To install the necessary
development dependencies required to run the tests, do:

    npm install

from the root directory. Subsequently, you can run the tests using
of the following command:

    npm test

[Hubot]: https://hubot.github.com/
[remind.coffee]: https://github.com/github/hubot-scripts/blob/master/src/scripts/remind.coffee)
[hubot-remind-at]: https://github.com/soh335/hubot-remind-at.git
[chrono]: http://wanasit.github.io/pages/chrono/
