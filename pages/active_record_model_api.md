---
layout: default
---

<div class="page-header">
  <h2>Model API</h2>
</div>

{% include project_navigation.html %}

Use the ActiveRecord model API to make your model filterable:

* Apply Filterrific to the model.
* Specify which scopes are available to Filterrific. This is a safety mechanism
  to prevent unauthorized access to your database. It is like `attr_accessible`,
  just for Filterrific.
* Define default filter settings.


Filterrific relies heavily on ActiveRecord scopes for filtering, so it is
important that you are familiar with how to use scopes. We have an entire page
dedicated to [scope patterns](/pages/active_record_scope_patterns.html).

In the code example below we have added the `filterrific` directive as well
as some ActiveRecord scopes to the example `User` class:


```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name
  # text: email
  # string: gender
  # integer: country_id
  # datetime: created_at

  # This directive enables Filterrific for the User class.
  # We define a default sorting by most recent sign ups, and then
  # we make a number of scopes available through Filterrific.
  filterrific(
    :defaults => {
      :sorted_by => 'created_at_desc'
    },
    :scope_names => %w[
      search_query
      sorted_by
      with_country_id
      with_created_at_gte
      with_created_at_lt
      with_gender
      with_role_id
    ]
  )

  # ActiveRecord association declarations
  belongs_to :country
  has_many :role_assignments
  has_many :roles, :through => :role_assignments

  # Scope definitions. We omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for details.
  scope :search_query, lambda { |query|
    # Filters users whose name or email matches the query
    ...
  }
  scope :sorted_by, lambda { |sort_key|
    # Sorts users by sort_key
    ...
  }
  scope :with_country_id, lambda { |country_ids|
    # Filters users with any of the given country_ids
    ...
  }
  scope :with_created_at_gte, lambda { |ref_datetime|
    # Filters users who signed up on or after ref_datetime
    ...
  }
  scope :with_created_at_lt, lambda { |ref_datetime|
    # Filters users who signed up before ref_datetime
    ...
  }
  scope :with_gender, lambda { |genders|
    # Filters users with any of the given genders
    ...
  }
  scope :with_role_id, lambda { |role_ids|
    # Filters users with any of the given role_ids
    ...
  }

end
```

<div class="pull-right">
  <a href="/pages/action_controller_api.html" class='btn btn-success'>Learn about the Controller API &rarr;</a>
</div>
