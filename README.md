# hubot-remind-at

yet another remind.coffee of hubot scripts

## Usage

```
Hubot> @hubot remind me at tomorrow 7:00 to wakeup!
I'll remind you to wakeup! at Sat Jan 17 2015 07:00:00 GMT+0900 (JST)
```

```
Hubot> Shell: you asked me to remind you to wakeup!
```

## Time Format

hubot-remind-at use [chrono](http://wanasit.github.io/pages/chrono/) is a natural language date parser in javascript.
So you can check format whichi hubot-remind-at parse on this site.

## Tests

hubot-remind-at comes with a test suite. To install the necessary
development dependencies required to run the tests, do:

    npm install

from the root directory. Subsequently, you can run the tests using
of the following command:

    npm test

## License

* MIT

## See Also

* [remind.coffee](https://github.com/github/hubot-scripts/blob/master/src/scripts/remind.coffee)
