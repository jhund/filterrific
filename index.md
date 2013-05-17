---
layout: default
---

<div class="page-header">
  <h1>Filterrific</h1>
</div>



{% include project_navigation.html %}

<p class="lead">
  Filterrific is a Rails Engine plugin that makes it easy to add filtering,
  searching, and sorting to your ActiveRecord lists.
</p>

<a href="http://filterrific-demo.herokuapp.com/students" class="btn btn-success btn-large">
  Check out the live demo!
</a>

It comes with the following features:

* Let your app's users search, filter and sort lists of ActiveRecord objects.
* Persist filter settings in the HTTP session or DB (for saved searches).
* Integrates with pagination.
* Filters can be reset to default settings.
* Relies on ActiveRecord scopes for building DB queries.
* Shuttles filter settings from a filter UI to the controller and ActiveRecord.
* Can be used for HTML/JS/JSON/XML response formats.

You only have to define the required ActiveRecord scopes and style your filter
form and record lists.

<div style="margin: 3em 0; max-width: 560px;" class="well">
  <blockquote style="margin-bottom: 0;">
    <p>
      I couldn't live without Filterrific. It makes it super easy to add
      user configurable reporting to my client projects.
    </p>
    <small>Jeff Ward, Animikii</small>
  </blockquote>
</div>

### How to use it

Let's say you want a list of students that can be filtered by your app's users.

#### 1) Add the gem to your app

```ruby
# Gemfile
gem 'filterrific'
```

#### 2) Add Filterrific to your `Student` model:

```ruby
filterrific(
  :default_settings => { :sorted_by => 'created_at_desc' },
  :filter_names => %w[search_query sorted_by with_country_id]
)
# define ActiveRecord scopes for
# :search_query, :sorted_by, and :with_country_id
```

#### 3) Use Filterrific in `StudentsController#index`:

```ruby
def index
  @filterrific = Filterrific.new(Student, params[:filterrific])
  @students = Student.filterrific_find(@filterrific).page(params[:page])

  respond_to do |format|
    format.html
    format.js
  end
end
```

#### 4) And finally build your view in `app/views/students/index.html.erb`:

<p class="unconstrained">
  <img src="/images/screenshot_s.png" alt="Filterrific in action" class="img-polaroid" />
  <div class="img_caption">
    Example 1: A simple student list that can be filtered.
  </div>
</p>

<p>
  <a href="/pages/example_application.html" class='btn btn-success'>Learn about the example application &rarr;</a>
</p>

<div class="row">

  <div class="span3">
    <h3>Resources</h3>
    <ul>
      <li><a href="http://filterrific.clearcove.ca">Documentation</a>
      <li><a href="http://filterrific-demo.herokuapp.com">Live demo</a>
      <li><a href="https://github.com/jhund/filterrific/blob/master/CHANGELOG.md">Changelog</a>
      <li><a href="https://github.com/jhund/filterrific">Source code</a>
      <li><a href="https://github.com/jhund/filterrific/issues">Issues</a>
      <li><a href="http://rubygems.org/gems/filterrific">Rubygems.org</a>
    </ul>
  </div>

  <div class="span4">
    <h3>Dependencies</h3>
    <ul>
      <li>Rails and ActiveRecord 3.x and 4</li>
      <li>jQuery and Asset pipeline for form observers and spinner</li>
    </ul>
  </div>

  <div class="span3">
    <h3>License</h3>
    <a href="https://github.com/jhund/filterrific/blob/master/MIT-LICENSE">MIT licensed</a>
    <h3>Copyright</h3>
    Copyright (c) 2010 - 2013 Jo Hund.
  </div>

</div>
