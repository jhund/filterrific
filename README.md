Filterrific
===========

User configurable filtering of ActiveRecord lists for your Rails app.

Filterrific is a collection of extensions for ActiveRecord and ActionView
that allow a developer to add user configurable filtering to ActiveRecord lists.

It comes with the following features:

* Let your app's users search, filter and sort lists of ActiveRecord objects.
* Add as many AND filter dimensions as you want.
* Persist filter settings in session or DB (for saved searches).
* Integrates with pagination.
* Filters can be reset to default settings.
* Relies on ActiveRecord scopes for building DB queries.
* Comes with the plumbing to shuttle filter settings from a filter UI to
  the controller and ActiveRecord.
* Can be used for JSON/XML/HTML response formats.


<div style="margin: 3em 0;">
  <blockquote>
    <p>
      I couldn't live without Filterrific. It makes it super easy to add
      user configurable reporting to my client projects.
    </p>
    <small>Jeff Ward, Animikii</small>
  </blockquote>
</div>


### Example app 1

---

<img src="http://filterrific.clearcove.ca/images/screenshot_c.png" alt="Filterrific in action"/>
<em>
  Example app 1: Filtering a list of members, with saved searches,
  pagination and filter reset. List at the left, filters to the right.
</em>

---

### Example app 2

---

<img src="http://filterrific.clearcove.ca/images/screenshot_q.png" alt="Filterrific in action"/>
<em>
  Example app 2: Filtering a list of questions. Filters above, list below.
</em>

---

### Details

* Filterrific takes care of shuttling filter settings from your view
  to ActiveRecord queries, and of returning matching records back to the view.
  You are responsible to implement the aspects that are specific
  to your application:
    * define the required scopes
    * style your filter form and record lists
* You use 3 APIs to integrate Filterrific into your app: Model, View and Controller.

Make sure to go to the fantastic [Filterrific documentation](http://filterrific.clearcove.ca)
to find out more!



### Dependencies

* Rails and ActiveRecord 3.x and 4
* PostgreSQL or MySQL
* Ruby 1.8.7 or greater
* jQuery and Asset pipeline for form observers and spinner


### Installation

`gem install filterrific`

or with bundler in your Gemfile:

`gem 'filterrific'`



### Resources

* [Documentation](http://filterrific.clearcove.ca)
* [Changelog](https://github.com/jhund/filterrific/blob/master/CHANGELOG.md)
* [Source code (github)](https://github.com/jhund/filterrific)
* [Issues](https://github.com/jhund/filterrific/issues)
* [Rubygems.org](http://rubygems.org/gems/filterrific)



### License

[MIT licensed](https://github.com/jhund/filterrific/blob/master/MIT-LICENSE).



### Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.



### Copyright

Copyright (c) 2010 - 2013 Jo Hund. See [(MIT) LICENSE](https://github.com/jhund/filterrific/blob/master/MIT-LICENSE) for details.
