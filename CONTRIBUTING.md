# Contributing to Meducation's Front End Libraries

First of all, **thank you** for contributing to these libraries.

## Issues 
Please file issues on the [GitHub issues list](https://github.com/meducation/front-end/issues) and give as much detail as possible.

## Features / Pull Requests

If you want a feature implemented, the best way to get it done is to submit a pull request that implements it. Please make sure it has tests. As this library is used primarily for Meducation, there needs to be some value to Meducation for your new feature to be accepted.

Please stick to the [CoffeeScript Style Guide](https://github.com/polarmobile/coffeescript-style-guide).

If you've not contributed to a repository before - this is the accepted pattern to use:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Setup

Presuming you have npm installed:

```
npm install -g grunt-cli bower
npm install
grunt
bundle
```

### Testing

To run the JavasScript tests, use `grunt test`.  This runs them via the terminal.  You can also open a HTML file to run them in a browser of your choice by serving `_SpecRunner.html`
To start a local server, use `grunt server watch`.

### Project Structure

- The `lib` directory contains files to be packaged up to create a Rails gem.
- The `vendor` directory is as above but used to include third party files required to make the gem function.
- The `src/server` directory contains the express.js server code.
- The `src/coffee` directory contains the CoffeeScript source files.
- The `src/test` directory contains the Jasmine unit tests.  External dependencies required by the tests are downloaded to `src/test/lib` via [Bower](http://bower.io/).

The following directories are generated during the development lifecycle:

- `.grunt`: Where the Jasmine test helper files live.
- `node_modules`: the home of the grunt project dependencies.
- `tmp`: Where the compiled JavaScript is written to, as well as test coverage data.  A compiled HTML templates file is also written here.

### Developing

Run `grunt --help` to see a list of available tasks and their explanations

The `server watch` tasks run a local express.js server hosting pages with example front end components.
When any of the source or test code changes, the default task is run and the express server is restarted so that changes are reflected upon browser refresh.
You can automate browser refresh on change by installing a [LiveReload](http://livereload.com/) browser plugin.

#### Versioning

Please remember to up the version at `lib/meducation_front_end/version.rb` after making changes.

Thank you again!
:heart: :sparkling_heart: :heart:

