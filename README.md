Filterrific
===========

Filterrific is a Rails Engine plugin that makes it easy to filter,
search, and sort your ActiveRecord lists:

***

![A filterrific enhanced list](https://github.com/jhund/filterrific/blob/gh-pages/images/screenshot_s.png)

***

Make sure to go to the fantastic [Filterrific documentation](http://filterrific.clearcove.ca)
to find out more!

### Installation

`gem install filterrific`

or with bundler in your Gemfile:

`gem 'filterrific'`


### Compatibility

Every commit to Filterrific is automatically tested against the following scenarios:

| Rails version | Ruby environments              | Database adapters                  | Build status |
|---------------|--------------------------------|------------------------------------|--------------|
| Rails 5.x     | MRI 2.0.0, 2.1.7, 2.2.3, 2.3.1 | mysql2, postgresql                 |[![Build Status](https://travis-ci.org/jhund/filterrific_demo.svg?branch=rails-5.x)](https://travis-ci.org/jhund/filterrific_demo)|
| Rails 4.2     | MRI 2.0.0, 2.1.7, 2.2.3, 2.3.1 | mysql, mysql2, postgresql, sqlite3 |[![Build Status](https://travis-ci.org/jhund/filterrific_demo.svg?branch=rails-4.2)](https://travis-ci.org/jhund/filterrific_demo)|
| Rails 4.1     | MRI 2.0.0, 2.1.7, 2.2.3, 2.3.1 | mysql, mysql2, postgresql, sqlite3 |[![Build Status](https://travis-ci.org/jhund/filterrific_demo.svg?branch=rails-4.1)](https://travis-ci.org/jhund/filterrific_demo)|
| Rails 4.0     | MRI 2.0.0, 2.1.7, 2.2.3, 2.3.1 | mysql, mysql2, postgresql, sqlite3 |[![Build Status](https://travis-ci.org/jhund/filterrific_demo.svg?branch=rails-4.0)](https://travis-ci.org/jhund/filterrific_demo)|
| Rails 3.2     | MRI 2.0.0, 2.1.7               | mysql, mysql2, postgresql, sqlite3 |[![Build Status](https://travis-ci.org/jhund/filterrific_demo.svg?branch=rails-3.2)](https://travis-ci.org/jhund/filterrific_demo)|

Filterrific version 1.x should work on older versions of Rails and Ruby, however
the 1.x branch is not supported any more.

Filterrific up to version 2.1.0 should work on Ruby 1.9.3, however we're not testing it any more. Time to move on to a more current version of Ruby.


### Guidelines for submitting issues

Please post questions related to usage at [StackOverflow](http://stackoverflow.com/questions/tagged/filterrific) under the `filterrific` tag.

If you think you've found a bug, or have a feature request, then create an issue here on Github. You'll make my job easier if you follow these guidelines:

* Please keep in mind that I do this in my spare time. To you this software is free as in `beer`, to me it's free as in `baby`. I appreciate it if you first do everything you can on your own: read the detailed [Filterrific documentation](http://filterrific.clearcove.ca), look for similar issues on [StackOverflow](http://stackoverflow.com/questions/tagged/filterrific), search the internets, etc.
* If you're stuck, give me sufficient context so that I have a chance to identify the issue:
    * what version of filterrific are you using? (look in your `Gemfile.lock`)
    * what version of Rails are you using? (look in your `Gemfile.lock`)
    * what version of Ruby are you using? (run `ruby -v` in your app root)
* If you get an exception, include the entire stack trace, including the error message.
* Include any relevant code snippets (your model, controller, and view code).
* When pasting code, please use [markdown code  formatting](https://help.github.com/articles/github-flavored-markdown/#fenced-code-blocks). It will be much easier to read.


### Resources

* [Documentation](http://filterrific.clearcove.ca)
* [Live demo](http://filterrific-demo.herokuapp.com)
* [Changelog](https://github.com/jhund/filterrific/blob/master/CHANGELOG.md)
* [Source code (github)](https://github.com/jhund/filterrific)
* [Issues](https://github.com/jhund/filterrific/issues)
* [Questions on Stack Overflow](http://stackoverflow.com/questions/tagged/filterrific) (tagged `filterrific`)
* [Rubygems.org](http://rubygems.org/gems/filterrific)

[![Build Status](https://travis-ci.org/jhund/filterrific.svg?branch=master)](https://travis-ci.org/jhund/filterrific)

[![Code Climate](https://codeclimate.com/github/jhund/filterrific.png)](https://codeclimate.com/github/jhund/filterrific)

### License

[MIT licensed](https://github.com/jhund/filterrific/blob/master/MIT-LICENSE).



### Copyright

Copyright (c) 2010 - 2016 Jo Hund. See [(MIT) LICENSE](https://github.com/jhund/filterrific/blob/master/MIT-LICENSE) for details.
