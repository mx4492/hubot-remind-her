# Hubot Remind Her

Hubot script to create reminders in a relaxed friendly syntax.

## Features

* Supports both relative ("in 5 minutes") and absolute ("tomorrow 5
  pm") time specification.
* The syntax of the bot command is relaxed. It simply DWYM (Does what
  you mean) without expecting much grammar.
* The confirmation given by the script uses a relative date instead of
  a scary complete ISOish date string.

## Installation

Install the npm package

    npm install hubot-remind-her --save

and add *hubot-remind-her* to `external-scripts.json`

    [ "hubot-remind-her" ]

Note: This script will not work in conjuction with [remind.coffee][] and
[hubot-remind-at][], so disable them if you are enabling this.

## Usage

If it is prefixed with `remind`, and ends with `to <something>`, and
has a date in between, it'll work.

```
> hubot remind me in 10 minutes to have fun
> hubot remind me tomorrow 10 PM to eat
> hubot remind me at 18 Feb to be alive
```

To get detailed help about the sort of time strings supported, see the
[chrono][] homepage.

## Tests

The first time around, you'll need to install the necessary development
dependencies required to run the tests:

    npm install

Subsequently, you can run the tests using:

    npm test

## History/Credits

This is a spiritual successor of the [remind.coffee][] and the
[hubot-remind-at][] scripts, combining their functionality, making the
command syntax more flexible, and the bot's responses more friendly.
All thanks to the awesomeness of [chrono][] and [moment.js][].

## Bugs

* Reminders longer that 24 days in the future are immediately
  triggered ([Reference][long-settimeout]).

[Hubot]: https://hubot.github.com/
[remind.coffee]: https://github.com/github/hubot-scripts/blob/master/src/scripts/remind.coffee)
[hubot-remind-at]: https://github.com/soh335/hubot-remind-at.git
[chrono]: http://wanasit.github.io/pages/chrono/
[long-settimeout]: http://stackoverflow.com/questions/12351521/can-settimeout-be-too-long
[moment.js]: http://momentjs.com/
