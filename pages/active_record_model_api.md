---
layout: default
nav_id: model_api
---

<div class="page-header">
  <h2>Model API</h2>
</div>

{% include site_navigation.html %}

Use the ActiveRecord model API to make your model filterrific:

* Apply Filterrific to the model.
* Specify which scopes are available to Filterrific. This is a safety mechanism
  to prevent unauthorized access to your database. It is like `strong_params`,
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
    default_filter_params: { sorted_by: "created_at_desc" },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_country_id,
      :with_created_at_gte,
    ],
  )

  # ActiveRecord association declarations
  belongs_to :country

  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
  scope :search_query, ->(query) {
    # Filters students whose name or email matches the query
    ...
  }
  scope :sorted_by, ->(sort_key) {
    # Sorts students by sort_key
    ...
  }
  scope :with_country_id, ->(country_ids) {
    # Filters students with any of the given country_ids
    ...
  }
  scope :with_created_at_gte, ->(ref_date) {
    ...
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Name (a-z)", "name_asc"],
      ["Registration date (newest first)", "created_at_desc"],
      ["Registration date (oldest first)", "created_at_asc"],
      ["Country (a-z)", "country_name_asc"],
    ]
  end

end
```

We also create a presenter method on Country to provide select options for the
`with_country_id` filter select input:

```ruby
# app/models/country.rb
def self.options_for_select
  order("LOWER(name)").map { |e| [e.name, e.id] }
end
```


<p>
  <a href="/pages/action_controller_api.html" class='btn btn-success'>Learn about the Controller API &rarr;</a>
</p>
