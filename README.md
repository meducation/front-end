# Meducation Front-end

A collection of single page applications for Meducation.

[![Build Status](https://travis-ci.org/meducation/front-end.png)](https://travis-ci.org/meducation/front-end)
[![Dependencies](https://gemnasium.com/meducation/front-end.png?travis)](https://gemnasium.com/meducation/front-end)
[![Code Climate](https://codeclimate.com/github/meducation/front-end.png)](https://codeclimate.com/github/meducation/front-end)
[![Coverage Status](https://coveralls.io/repos/meducation/front-end/badge.png)](https://coveralls.io/r/meducation/front-end)

## Installation

Add this line to your application's Gemfile:

    gem 'meducation-front-end'

If you want to use the latest version from Github, you can do:

    gem 'meducation-front-end', github: "meducation/front-end"

And then execute:

    $ bundle

Place the following in `app/assets/javascripts.js`.

    //= require angular/angular
    // ... add any other vendor scripts here ...
    //= require meducation_front_end


## Contributing

Firstly, thank you!! :heart::sparkling_heart::heart:

Presuming you have npm and ruby installed, install everything else with:

```
npm install -g grunt-cli
npm install
grunt
bundle
```

To run the JavasScript tests, use `grunt test`.
To start a local server, use `grunt server`.

To help:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Licence

Copyright (C) 2013 New Media Education Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

A copy of the GNU Affero General Public License is available in [Licence.md](https://github.com/meducation/front-end/blob/master/LICENCE.md)
along with this program.  If not, see <http://www.gnu.org/licenses/>.
