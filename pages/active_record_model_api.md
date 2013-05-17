---
layout: default
---

<div class="page-header">
  <h2>Model API</h2>
</div>

{% include project_navigation.html %}

Use the ActiveRecord model API to make your model filterrific:

* Apply Filterrific to the model.
* Specify which scopes are available to Filterrific. This is a safety mechanism
  to prevent unauthorized access to your database. It is like `attr_accessible`,
  just for filter settings.
* Define default filter settings.

Filterrific relies heavily on ActiveRecord scopes for filtering, so it is
important that you are familiar with how to use scopes. We have an entire page
dedicated to [scope patterns](/pages/active_record_scope_patterns.html).

In the code example below we have added the `filterrific` directive as well
as some ActiveRecord scopes to the example `Student` class:


```ruby
# app/models/student.rb
class Student < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: first_name
  # string: last_name
  # text: email
  # integer: country_id
  # datetime: created_at

  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    :default_settings => { :sorted_by => 'created_at_desc' },
    :filter_names => [
      :sorted_by,
      :search_query,
      :with_country_id,
      :with_created_at_gte
    ]
  )

  # ActiveRecord association declarations
  belongs_to :country

  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
  scope :search_query, lambda { |query|
    # Filters students whose name or email matches the query
    ...
  }
  scope :sorted_by, lambda { |sort_key|
    # Sorts students by sort_key
    ...
  }
  scope :with_country_id, lambda { |country_ids|
    # Filters students with any of the given country_ids
    ...
  }
  scope :with_created_at_gte, lambda { |ref_date|
    ...
  }

end
```

<a href="/pages/action_controller_api.html" class='btn btn-success'>Learn about the Controller API &rarr;</a>
