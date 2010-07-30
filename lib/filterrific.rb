This Rails plugin makes it super simple to add filtering to your rails list views.

Some of the features:
---------------------

* RESTful
* conditions, sorting, maybe grouping?
* works with pagination
* settings can be persisted in session or via database for saved searches
* works with ActiveRecord
* gets along well with will_paginate

Here is some code:
------------------

In your model:

class Task < ActiveRecord::Base

  has_filter_settings :defaults => { :sorted_by => "updated_at_desc" }

end

In your controller:

class TasksController < ApplicationController

  def index
    put filterrific code here ...
  end

end

In your view:

render filter
render list info
render list


Possibilities:
-------------

* integrate with thinking_sphinx
* integrate with formtastic
* integrate with will_paginate
* integrate with make_resourceful

Here is how it works:
---------------------

Filterrific relies heavily on scopes. Each filter dimension has its own scope. Filterrific makes it easy to shuttle user settings to your controllers and models for queries, and back to the views.



